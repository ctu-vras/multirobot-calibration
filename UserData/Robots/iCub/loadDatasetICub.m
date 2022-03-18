function datasets = loadDatasetICub(robot,optim, chains, varargin )
%LOADDATASETICUB Function for loading iCub dataset
% Custom function for loading iCub dataset IROS2018 or ICRA2019.
% INPUT - rob - object of class Robot
%       - optim - calibration options (not used here)
%       - chains - structure containing which chains will be calibrated
%       - varargin - cellarray of arguments to specify which datasets will
%       be used - vector(1x5) or cellarray(1x4} or string 'leica'
%   OUTPUT - datasets - 1x4 ([self-touch, planes, external, projection]) 
%                       cell array of cell arrays (1xN) of datasets

    %third varargin is the name of dataset(s), default is ICRA2019 dataset   
    varargin = varargin{1};
    if(length(varargin) == 3)
        source_files = {varargin{3}};
    else
        source_files = {'selfTouchConfigs_ICRA2019.log'}; 
    end
    chain = '';
    if(length(varargin) >= 2)
        chain = varargin{2};
    end
    nmb_of_files = length(source_files);
    datasets.selftouch = cell(1,nmb_of_files);  %datasets cell array MUST BE ROW VECTOR
    datasets.projection = {};
    DEG2RAD = pi/180;
    % all possible robot fingers
    %fingers={'rightThumb','rightIndex','rightMiddle','leftThumb','leftIndex','leftMiddle'}; 
    %for finger=fingers
    %    matrices.(finger{1})=dhpars2tfmat(robot.structure.kinematics.(finger{1})); 
    %end
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
            nmbPoses = varargin{1};
            if ischar(nmbPoses)
                nmbPoses = str2double(nmbPoses);
            end
        end
        data2(nmbPoses+1:end,:) = [];
        eyeAngle = data2(:,29)/2;
        dataset.joints = struct('torso', num2cell([zeros(size(data2,1),1),data2(:,4:5)*DEG2RAD],2), 'leftArm',num2cell(data2(:, [6:13])*DEG2RAD,2),...
            'rightArm',num2cell(data2(:, [6,17:23])*DEG2RAD,2), 'head',num2cell(data2(:, [6,24:26])*DEG2RAD,2),...
            'leftEye',num2cell([data2(:, 27),data2(:,28)+eyeAngle]*DEG2RAD,2), 'rightEye',num2cell([data2(:, 27),data2(:,28)-eyeAngle]*DEG2RAD,2));
        
        % precompute rt matrices
        for i = size(data2,1):-1:1
            mat.torso = getTFtoFrame(robot.structure.kinematics, robot.links{4},  dataset.joints(i));
            if(chains.leftArm == 0)
                dhleft=robot.structure.kinematics.leftArm;
                dhleft(:,end)=dhleft(:,end)+dataset.joints(i).leftArm';
                mat.leftArm = dhpars2tfmat(dhleft);
            end
            if(chains.rightArm == 0)
                dhright=robot.structure.kinematics.rightArm;
                dhright(:,end)=dhright(:,end)+dataset.joints(i).rightArm';
                mat.rightArm = dhpars2tfmat(dhright);
            end
            if(chains.leftEye == 0)
                dhleft=robot.structure.kinematics.leftEye;
                dhleft(:,end)=dhleft(:,end)+dataset.joints(i).leftEye';
                mat.leftEye = dhpars2tfmat(dhleft);
            end
            if(chains.rightEye == 0)
                dhright=robot.structure.kinematics.rightEye;
                dhright(:,end)=dhright(:,end)+dataset.joints(i).rightEye';
                mat.rightEye = dhpars2tfmat(dhright);
            end
            if(chains.head == 0)
                dhhead=robot.structure.kinematics.head;
                dhhead(:,end)=dhhead(:,end)+dataset.joints(i).head';
                mat.head = dhpars2tfmat(dhhead);
            end
            %for finger=fingers
            %    mat.(finger{1})=matrices.(finger{1}); 
            %end
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
        dataset.name = 'self-touch';
        datasets.selftouch{k} = dataset; 
        if(contains(chain, 'Eye'))
            types = robot.structure.type;
            % projection dataset is doubled touch dataset
            dataset2.frame =  reshape([dataset.frame'; dataset.frame2'],[],1);
            dataset2.point =  reshape([dataset.point'; dataset.point'],[],6);
            dataset2.joints = reshape([dataset.joints'; dataset.joints'],[],1);
            dataset2.rtMat = reshape([dataset.rtMat'; dataset.rtMat'],[],1);
            dataset2.pose = reshape([dataset.pose'; dataset.pose'],[],1);
            % both cameras logged the end effector position
            dataset2.cameras = zeros(2*size(data2,1),2);
            if(contains(chain, 'REye') || contains(chain, 'LREye'))
                dataset2.cameras(:,1) = 1;
            end
            if(contains(chain, 'LEye') || contains(chain, 'LREye'))
                dataset2.cameras(:,2) = 1;
            end
            cam_frames = robot.findLinkByType('eye');
            dh_pars = robot.structure.kinematics;
            right_finger = robot.findLink('rightHandFinger');
            left_finger = robot.findLink('leftHandFinger');
            parents = struct('rightArm', robot.links{3}, 'leftArm', robot.links{3}, 'torso', robot.links{1}, ...
                'head', robot.links{3}, 'leftEye', robot.links{23}, 'rightEye', robot.links{23});
            DHindexes.rightHandFinger = struct('rightArm', 1:8, 'torso', 1:2);
            DHindexes.leftHandFinger = struct('leftArm', 1:8, 'torso', 1:2);
            DHindexes.rightEyeVergence = struct('head', 1:4, 'torso', 1:2, 'rightEye', 1:2);
            DHindexes.leftEyeVergence = struct('head', 1:4, 'torso', 1:2, 'leftEye', 1:2);
            rtFields = fieldnames(dataset.rtMat(1));
            % simulated dataset has no refPoints for projections, so that they have to be created
            points2Cam = nan(4, 2*sum(dataset2.cameras(1,:))*size(data2, 1));
            if(contains(chain, 'LREye'))
                for i = 1:size(data2, 1)     
                    rtMat = dataset.rtMat(i);
                    points2Cam(:,4*i-3) =  inversetf(getTFIntern(dh_pars,cam_frames{1},rtMat, dataset.joints(i), DHindexes.leftEyeVergence, parents, rtFields, types))*...
                        (getTFIntern(dh_pars,right_finger{1},rtMat, dataset.joints(i), DHindexes.rightHandFinger, parents, rtFields, types)*[0;0;0;1]);
                    points2Cam(:,4*i-2) =  inversetf(getTFIntern(dh_pars,cam_frames{2},rtMat, dataset.joints(i), DHindexes.rightEyeVergence, parents, rtFields, types))*...
                    (getTFIntern(dh_pars,right_finger{1},rtMat, dataset.joints(i), DHindexes.rightHandFinger, parents, rtFields, types)*[0;0;0;1]);
                    points2Cam(:,4*i-1) =  inversetf(getTFIntern(dh_pars,cam_frames{1},rtMat, dataset.joints(i), DHindexes.leftEyeVergence, parents, rtFields, types))*...
                        (getTFIntern(dh_pars,left_finger{1},rtMat, dataset.joints(i), DHindexes.leftHandFinger, parents, rtFields, types)*[0;0;0;1]);
                    points2Cam(:,4*i) =  inversetf(getTFIntern(dh_pars,cam_frames{2},rtMat, dataset.joints(i), DHindexes.rightEyeVergence, parents, rtFields, types))*...
                    (getTFIntern(dh_pars,left_finger{1},rtMat, dataset.joints(i), DHindexes.leftHandFinger, parents, rtFields, types)*[0;0;0;1]);
                end 
                projs = projections(points2Cam, robot.structure.eyes, dataset2.cameras);
                dataset2.refPoints = reshape(projs, 4,2*nmbPoses)';
            elseif(contains(chain,'REye'))
                for i = 1:size(data2, 1)     
                    rtMat = dataset.rtMat(i);
                    points2Cam(:,2*i-1) =  inversetf(getTFIntern(dh_pars,cam_frames{1},rtMat, dataset.joints(i), DHindexes.leftEyeVergence, parents, rtFields, types))*...
                        (getTFIntern(dh_pars,right_finger{1},rtMat, dataset.joints(i), DHindexes.rightHandFinger, parents, rtFields, types)*[0;0;0;1]);
                    points2Cam(:,2*i) =  inversetf(getTFIntern(dh_pars,cam_frames{1},rtMat, dataset.joints(i), DHindexes.leftEyeVergence, parents, rtFields, types))*...
                        (getTFIntern(dh_pars,left_finger{1},rtMat, dataset.joints(i), DHindexes.leftHandFinger, parents, rtFields, types)*[0;0;0;1]);
                end 
                projs = projections(points2Cam, robot.structure.eyes, dataset2.cameras);
                dataset2.refPoints = [projs;nan(2,length(points2Cam))]';
            elseif(contains(chain,'LEye'))
                for i = 1:size(data2, 1)     
                    rtMat = dataset.rtMat(i);
                    points2Cam(:,2*i-1) =  inversetf(getTFIntern(dh_pars,cam_frames{2},rtMat, dataset.joints(i), DHindexes.rightEyeVergence, parents, rtFields, types))*...
                    (getTFIntern(dh_pars,right_finger{1},rtMat, dataset.joints(i), DHindexes.rightHandFinger, parents, rtFields, types)*[0;0;0;1]);
                    points2Cam(:,2*i) =  inversetf(getTFIntern(dh_pars,cam_frames{2},rtMat, dataset.joints(i), DHindexes.rightEyeVergence, parents, rtFields, types))*...
                    (getTFIntern(dh_pars,left_finger{1},rtMat, dataset.joints(i), DHindexes.leftHandFinger, parents, rtFields, types)*[0;0;0;1]);
                end
                projs = projections(points2Cam, robot.structure.eyes, dataset2.cameras);
                dataset2.refPoints = [nan(2,length(points2Cam));projs]';
            end
            dataset2.name = 'proj';
            datasets.projection{k} = dataset2;  
        end           
    end
%     datasets = {datasets.selftouch,{},{}, datasets.projection};
end


