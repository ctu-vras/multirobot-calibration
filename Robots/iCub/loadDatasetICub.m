function [ datasets, indexes ] = loadDatasetICub(robot,optim, chains, varargin )
%LOADDATASETICUB Function for loading iCub dataset
% Custom function for loading iCub dataset IROS2018 or ICRA2019.
% INPUT - rob - object of class Robot
%       - optim - calibration options (not used here)
%       - chains - structure containing which chains will be calibrated
%       - varargin - cellarray of arguments to specify which datasets will
%       be used - vector(1x5) or cellarray(1x4} or string 'leica'
% OUTPUT - datasets - structure containing datasets for calibration
%        - indexes - cellarray of indexes to datasets to separate them into
%        specific datasets (self-touch, planes (not used), external (not used), projections)

    %third varargin is the name of dataset(s), default is ICRA2019 dataset
    if(length(varargin) == 3)
        source_files = {varargin{3}{1}};
    else
        source_files = {'selfTouchConfigs_ICRA2019.log'}; 
    end
    if(length(varargin) >= 2)
        chain = varargin{2}{1};
    end
    nmb_of_files = length(source_files);
    datasets = cell(1,nmb_of_files*2);  %datasets cell array MUST BE ROW VECTOR
    DEG2RAD = pi/180;
    % all possible robot fingers
    fingers={'rightThumb','rightIndex','rightMiddle','leftThumb','leftIndex','leftMiddle'}; 
    for finger=fingers
        matrices.(finger{1})=dhpars2tfmat(robot.structure.DH.(finger{1})); 
    end
    for k = 1:nmb_of_files
        dataset.cameras = [];
        f = strsplit(source_files{k}, '.');
        data2 = load(['Dataset/',source_files{k}]);
        path = sprintf('Dataset/distances_%s.mat', f{1});
        distances = load(path);
        % sort touches from smallest to highest distance between end effectors
        [~, idxs] = sort(distances.distances);
        data2 = data2(idxs,:);
        % first varargin is number of poses selected from original dataset
        if(isempty(varargin))
            nmbPoses = length(idxs);
        else
            nmbPoses = varargin{1}{1};
        end
        data2(nmbPoses+1:end,:) = [];
        eyeAngle = data2(:,29)/2;
        dataset.joints = struct('torso', num2cell(data2(:,4:5)*DEG2RAD,2), 'leftArm',num2cell(data2(:, [6:13])*DEG2RAD,2),...
            'rightArm',num2cell(data2(:, [6,17:23])*DEG2RAD,2), 'head',num2cell(data2(:, [6,24:26])*DEG2RAD,2),...
            'leftEye',num2cell([data2(:, 27),data2(:,28)+eyeAngle]*DEG2RAD,2), 'rightEye',num2cell([data2(:, 27),data2(:,28)-eyeAngle]*DEG2RAD,2));
        
        % precompute rt matrices
        for i = size(data2,1):-1:1
            dhtorso=robot.structure.DH.torso;
            dhtorso(:,4)=dhtorso(:,4)+dataset.joints(i).torso';
            mat.torso = robot.structure.H0 * dhpars2tfmat(dhtorso);
            if(chains.leftArm == 0)
                dhleft=robot.structure.DH.leftArm;
                dhleft(:,4)=dhleft(:,4)+dataset.joints(i).leftArm';
                mat.leftArm = dhpars2tfmat(dhleft);
            end
            if(chains.rightArm == 0)
                dhright=robot.structure.DH.rightArm;
                dhright(:,4)=dhright(:,4)+dataset.joints(i).rightArm';
                mat.rightArm = dhpars2tfmat(dhright);
            end
            if(chains.leftEye == 0)
                dhleft=robot.structure.DH.leftEye;
                dhleft(:,4)=dhleft(:,4)+dataset.joints(i).leftEye';
                mat.leftEye = dhpars2tfmat(dhleft);
            end
            if(chains.rightEye == 0)
                dhright=robot.structure.DH.rightEye;
                dhright(:,4)=dhright(:,4)+dataset.joints(i).rightEye';
                mat.rightEye = dhpars2tfmat(dhright);
            end
            if(chains.head == 0)
                dhhead=robot.structure.DH.head;
                dhhead(:,4)=dhhead(:,4)+dataset.joints(i).head';
                mat.head = dhpars2tfmat(dhhead);
            end
            for finger=fingers
                mat.(finger{1})=matrices.(finger{1}); 
            end
            dataset.rtMat(i) = mat;
        end
        dataset.rtMat = reshape(dataset.rtMat, size(data2,1),1);
        dataset.point = zeros(size(data2,1),6);
        dataset.pose = (1:size(data2,1))';
        C = cell(size(data2,1),1);
        C(:) = {'rightHandFinger'}; % right end effector
        dataset.frame = C;
        C(:) = {'leftHandFinger'}; % left end effector
        dataset.frame2 = C;
        dataset.refPoints = data2(:,1:3);        
        
        % projection dataset is doubled touch dataset
        dataset2.frame =  reshape([dataset.frame'; dataset.frame2'],[],1);
        dataset2.point =  reshape([dataset.point'; dataset.point'],[],6);
        dataset2.joints = reshape([dataset.joints'; dataset.joints'],[],1);
        dataset2.rtMat = reshape([dataset.rtMat'; dataset.rtMat'],[],1);
        dataset2.pose = reshape([dataset.pose'; dataset.pose'],[],1);
        % both cameras logged the end effector position
        dataset2.cameras = ones(2*size(data2,1),2);
%         if(strfind(chain, 'REye'))
%         end
        points2Cam = nan(4, 4*size(data2, 1));
        cam_frames = robot.findJointByType('eye');
        dh_pars = robot.structure.defaultDH;
        H0 = robot.structure.H0;
        right_finger = robot.findJoint('rightHandFinger');
        left_finger = robot.findJoint('leftHandFinger');
        parents = struct('rightArm', robot.joints{3}, 'leftArm', robot.joints{3}, 'torso', robot.joints{1}, ...
            'head', robot.joints{3}, 'leftEye', robot.joints{23}, 'rightEye', robot.joints{23});
        DHindexes.rightHandFinger = struct('rightArm', 1:8, 'torso', 1:2);
        DHindexes.leftHandFinger = struct('leftArm', 1:8, 'torso', 1:2);
        DHindexes.rightEyeVergence = struct('head', 1:4, 'torso', 1:2, 'rightEye', 1:2);
        DHindexes.leftEyeVergence = struct('head', 1:4, 'torso', 1:2, 'leftEye', 1:2);
        rtFields = fieldnames(dataset.rtMat(1));
        % simulated dataset has no refPoints for projections, so that they have to be created
        for i = 1:size(data2, 1)     
            rtMat = dataset.rtMat(i);
            points2Cam(:,4*i-3) =  inversetf(getTFIntern(dh_pars,cam_frames{1},rtMat, dataset.joints(i), H0, DHindexes.leftEyeVergence, parents, rtFields))*...
                (getTFIntern(dh_pars,right_finger{1},rtMat, dataset.joints(i), H0, DHindexes.rightHandFinger, parents, rtFields)*[0;0;0;1]);
            points2Cam(:,4*i-2) =  inversetf(getTFIntern(dh_pars,cam_frames{2},rtMat, dataset.joints(i), H0, DHindexes.rightEyeVergence, parents, rtFields))*...
            (getTFIntern(dh_pars,right_finger{1},rtMat, dataset.joints(i), H0, DHindexes.rightHandFinger, parents, rtFields)*[0;0;0;1]);
            points2Cam(:,4*i-1) =  inversetf(getTFIntern(dh_pars,cam_frames{1},rtMat, dataset.joints(i), H0, DHindexes.leftEyeVergence, parents, rtFields))*...
                (getTFIntern(dh_pars,left_finger{1},rtMat, dataset.joints(i), H0, DHindexes.leftHandFinger, parents, rtFields)*[0;0;0;1]);
            points2Cam(:,4*i) =  inversetf(getTFIntern(dh_pars,cam_frames{2},rtMat, dataset.joints(i), H0, DHindexes.rightEyeVergence, parents, rtFields))*...
            (getTFIntern(dh_pars,left_finger{1},rtMat, dataset.joints(i), H0, DHindexes.leftHandFinger, parents, rtFields)*[0;0;0;1]);
        end       
        projs = projections(points2Cam, robot.structure.eyes, dataset2.cameras);
        
        dataset2.refPoints = reshape(projs, 4,2*nmbPoses)';
        datasets{k} = dataset; 
        datasets{k+nmb_of_files} = dataset2;       
    end
    indexes = {1:nmb_of_files, [] ,[], nmb_of_files+1:nmb_of_files*2};
end

