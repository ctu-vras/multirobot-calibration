function [ datasets, indexes ] = loadDatasetICub(robot,optim, chains, varargin )
%LOADDATASETICUB Summary of this function goes here
%   Detailed explanation goes here
    if(length(varargin) == 2)
        source_files = {varargin{2}{1}};
    else
        source_files = {'selfTouchConfigs_ICRA2019.log'};
    end
    nmb_of_files = length(source_files);
    datasets = cell(1,nmb_of_files*2);  %datasets cell array MUST BE ROW VECTOR
    DEG2RAD = pi/180;
    fingers={'rightThumb','rightIndex','rightMiddle','leftThumb','leftIndex','leftMiddle'};
    for k = 1:nmb_of_files
        for finger=fingers
           matrices.(finger{1})=dhpars2tfmat(robot.structure.DH.(finger{1})); 
        end
        dataset.cameras = [];
        dataset.rtMat = [];
        f = strsplit(source_files{k}, '.');
        data2 = load(['Dataset/',source_files{k}]);
        path = sprintf('Dataset/distances_%s.mat', f{1});
        distances = load(path);
        [~, idxs] = sort(distances.distances);
        data2 = data2(idxs,:);
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
        
        for i = 1:size(data2,1)
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
            for finger=fingers
                mat.(finger{1})=matrices.(finger{1}); 
            end
            dataset.rtMat = [dataset.rtMat;mat];
        end
        
        dataset.point = zeros(size(data2,1),6);
        dataset.pose = (1:size(data2,1))';
        C = cell(size(data2,1),1);
        C(:) = {'rightHandFinger'};
        dataset.frame = C;
        C(:) = {'leftHandFinger'};
        dataset.frame2 = C;
       
        dataset.refPoints = data2(:,1:3);
            
        dataset2.frame =  reshape([dataset.frame'; dataset.frame2'],[],1);
        dataset2.point =  reshape([dataset.point'; dataset.point'],[],6);
        dataset2.joints = reshape([dataset.joints'; dataset.joints'],[],1);
        dataset2.rtMat = reshape([dataset.rtMat'; dataset.rtMat'],[],1);
        dataset2.pose = reshape([dataset.pose'; dataset.pose'],[],1);
        dataset2.cameras = ones(2*size(data2,1),2);
        points2Cam = nan(4, 4*size(data2, 1));
        cam_frames = robot.findJointByType('eye');
        dh_pars = robot.structure.DH;
        H0 = robot.structure.H0;
        right_finger = robot.findJoint('rightHandFinger');
        left_finger = robot.findJoint('leftHandFinger');
        for i = 1:size(data2, 1)      
            rtMat = dataset.rtMat(i);
            points2Cam(:,4*i-3) =  inversetf(getTF(dh_pars,cam_frames{1},rtMat, false, dataset.joints(i), H0))*...
                (getTF(dh_pars,right_finger{1},rtMat, false, dataset.joints(i), H0)*[0;0;0;1]);
            points2Cam(:,4*i-2) =  inversetf(getTF(dh_pars,cam_frames{2},rtMat, false, dataset.joints(i), H0))*...
            (getTF(dh_pars,right_finger{1},rtMat, false, dataset.joints(i), H0)*[0;0;0;1]);
            points2Cam(:,4*i-1) =  inversetf(getTF(dh_pars,cam_frames{1},rtMat, false, dataset.joints(i), H0))*...
                (getTF(dh_pars,left_finger{1},rtMat, false, dataset.joints(i), H0)*[0;0;0;1]);
            points2Cam(:,4*i) =  inversetf(getTF(dh_pars,cam_frames{2},rtMat, false, dataset.joints(i), H0))*...
            (getTF(dh_pars,left_finger{1},rtMat, false, dataset.joints(i), H0)*[0;0;0;1]);
        end
        
        
        projs = projections(points2Cam, robot.structure.eyes, dataset2.cameras);
        dataset2.refPoints = reshape(projs, 4,2*nmbPoses)';
        datasets{k} = dataset; 
        datasets{k+nmb_of_files} = dataset2;
        
        
    end
    indexes = {1:nmb_of_files, [] ,[], nmb_of_files+1:nmb_of_files*2};
end

