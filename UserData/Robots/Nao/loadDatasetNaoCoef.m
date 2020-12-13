function datasets = loadDatasetNaoCoef(robot,optim, chains, varargin)
    % LOADDATASETNAO returns 'datasets' and 'indexes' for given
    % optimization settings. 
    %   INPUT - robot - instance of @robot class
    %         - optim - structure with optimization settings
    %         - chains - structure with optimized chains
    %         - datasetNames - 1xN cell array with names of the
    %           datasets, e.g. {'rightArm_torso'}
    %   OUTPUT - datasets - 1x4 ([self-touch, planes, external, projection]) 
    %                       cell array of cell arrays (1xN) of datasets
    varargin=varargin{1};
    if length(varargin)==1
        alt=0;
        datasetsNames=varargin;
    else
        if strfind(varargin{end},'Alt')
            alt=1;
            datasetsNames=varargin{1:end-1};
        else
            alt=0;
            datasetsNames=varargin;
        end    
    end
    %datasetsNames=varargin{1};
    % Assign robot's DH into new variable
    DH=robot.structure.DH;
    if size(DH.leftArm,2)==4
       [DH, ~] = padVectors(DH); 
    end
    % Add 'dummy' torso link to precompute RT matrices
    DH.torso=[0,0,nan,0,0,nan];
    % Variables init
    datasets.selftouch=cell(1,length(datasetsNames));
    for name=1:length(datasetsNames)
        % Split dataset name to get names of the chains
        spl=strsplit(datasetsNames{name},'_');
        chain1=spl{1};
        chain2=spl{2};
        if contains(chain1, 'Finger') || contains(chain2, 'Finger')
           finger=1;
        else
            finger=0;
        end
        % If chain1 is not being optimized, swap the chains
        %if ~finger
        if ~chains.(chain1)
          chain1=spl{2};
          chain2=spl{1};
        end
        %end
        % Split string with word 'Arm' to get just side ...right for
        % rightArm, '' for Torso
%         if ~finger 
%             name1=strsplit(chain1,'Arm');
%             name1=name1{1};
%             name2=strsplit(chain2,'Arm');
%             name2=name2{1};
%         else
%             name1=strsplit(chain1,'Finger');
%             name1=name1{1};
%             name2=strsplit(chain2,'Finger');
%             name2=name2{1};
%         end
        
        if contains(chain1, 'Arm')
            name1=strsplit(chain1,'Arm');
            name1=name1{1};
        elseif contains(chain1, 'Finger')
            name1=strsplit(chain1,'Finger');
            name1=name1{1};
        else
            name1 = chain1;
        end

        if contains(chain2, 'Arm')
            name2=strsplit(chain2,'Arm');
            name2=name2{1};
        elseif contains(chain2, 'Finger')
            name2=strsplit(chain2,'Finger');
            name2=name2{1};
        else
            name2=chain2;
        end
        
        % call prepareData to get current values
        taxelStruct=prepareDataCoef(robot,datasetsNames{name},chain1,chain2,DH,alt,chains, optim);
        %Init dataset 
        dataset.point = []; % Points in local frame Mx3 (Mx6 if no refPoint)
        dataset.pose = []; % Mx1 int id of pose
        dataset.frame = {}; % Mx1 instance of joint (chain1)
        dataset.frame2 = {}; % Mx1 instance of joint (chain2)
        dataset.joints = []; % Mx1 structure of joints angles (fields are 'group' names...rightArm, rightArmSkin...)
        dataset.cameras = [];  
        dataset.refPoints = []; % Mx3(Mx6) aray of refPoints (precomputed points) 
        dataset.rtMat = []; % Mx1 strucure of precomputed RT matrices (fields are the same as in 'joints')
        % defined in prepareData()
        dataset.mins=[]; 
        dataset.difs=[];
        dataset.cops=[];
        dataset.cop=[];
        dataset.newTaxelsNA=[];
        dataset.newTaxels=[];
        %if ~finger
            dataset.name=strcat(chain1,'_',chain2);
        %else
        %    dataset.name=strcat(chain1,'_',name2,'Finger');
        %end
        %Load taxels in local frames
        if ~ismember(chain1, {'leftFinger', 'rightFinger'})
            if ~alt
                chain1Original = zeros(384,6);
            else
                firstLocal = importdata(strcat('Dataset/Points/',chain1,'.txt'),' ',4);
                chain1Original=firstLocal.data;
            end
        else
            chain1Original = [0,0,0]; 
        end
        
        if ~ismember(chain2, {'leftFinger', 'rightFinger'})
            if ~alt
                chain2Original = zeros(384, 6);
            else
                firstLocal = importdata(strcat('Dataset/Points/',chain2,'.txt'),' ',4);
                chain2Original=firstLocal.data;
            end
        else
            chain2Original = [0,0,0];
        end
        %else
        %    chain2Original = [0,0,0]; 
        %end
        poseID=1;
        %Iterate over all 32 triangles (maximal number on one chain)
        for triangleId=0:31
                %Init temp variables
                datasetLocal.point = [];
                datasetLocal.pose = [];
                datasetLocal.frame = {};
                datasetLocal.frame2 = {};
                datasetLocal.joints = [];
                datasetLocal.cameras = [];
                datasetLocal.refPoints = [];
                datasetLocal.rtMat = [];
                datasetLocal.mins=[];
                datasetLocal.difs=[];
                datasetLocal.numberOfCops=[];
                datasetLocal.numberOfTaxels=[];
                datasetLocal.cops=[];
                datasetLocal.cop=[];
                datasetLocal.newTaxelsNA=[];
                datasetLocal.newTaxels=[];
                %Iterate over 12 taxels on each triangle
                for taxelId=1:12
                    index=triangleId*12+taxelId;
                    %check if there is field with given index and if there
                    %is more than X (0) values in it
                    if isstruct(taxelStruct.(strcat('s',num2str(index)))) && size(taxelStruct.(strcat('s',num2str(index))).secondTaxel,1)>0
                        % In each field of 'taxelStruct' there can be more
                        % records
                        for i=1:size(taxelStruct.(strcat('s',num2str(index))).secondTaxel,1)
                            % Joint angles for given activation
                            angles=taxelStruct.(strcat('s',num2str(index))).angles(i);
                            %index of second taxel (in 'chain2Original')
                            a=taxelStruct.(strcat('s',num2str(index))).secondTaxelId(i);
                            %If refPoint should be used and only one chain
                            %is being optimized
                            %if ~finger
                            c2=chain2;
                            %else
                            %    c2=[name2,'Finger'];
                            %end
                            if optim.refPoints && ~all([chains.(chain1),chains.(c2)])
                                % Take refPoint of chain2
                                datasetLocal.refPoints=[datasetLocal.refPoints;taxelStruct.(strcat('s',num2str(index))).secondTaxel(i,:)];
                                % Assing taxel on chain1 in local frame
                                datasetLocal.point=[datasetLocal.point;chain1Original(index,1:3)];%.*1000
                            else
                                %Assign taxel on chain1,chain2 in local
                                %frames
                                datasetLocal.point=[datasetLocal.point;chain1Original(index,1:3),chain2Original(a,1:3)];%.*1000,.*1000
                            end
                            datasetLocal.joints=[datasetLocal.joints;angles];
                            %Find frame from string, e.g. rightTriangle15
                            if ~ismember(chain1, {'leftFinger', 'rightFinger'})
                                datasetLocal.frame{end+1,1}=strcat(name1,'Taxel',num2str(triangleId),'_',num2str(taxelId-1));
                            else
                                datasetLocal.frame{end+1,1}=chain1;
                            end
                            % Find frame of second taxel...integer division of (a-1)/12
                            % a-1 because a is in matlab indexing and
                            % triangles are numbered from 0
                            %e.g. a=12...a//12=1, but we need (a-1)//12=0
                            if ~ismember(chain2, {'leftFinger', 'rightFinger'})
                                datasetLocal.frame2{end+1,1} = strcat(name2,'Taxel',num2str(fix((a-1)/12)),'_',num2str(mod(a-1,12)));                            
                            else
                                datasetLocal.frame2{end+1,1} = chain2;
                            end
                            %datasetLocal.pose=[datasetLocal.pose;fix((a-1)/12)];
                            datasetLocal.pose=[datasetLocal.pose;poseID];
                            % Assing mins and difs...just for visualization
                            datasetLocal.mins=[datasetLocal.mins;taxelStruct.(strcat('s',num2str(index))).mins(i)];
                            datasetLocal.difs=[datasetLocal.difs;taxelStruct.(strcat('s',num2str(index))).difs(i,:)];
                            poseID=poseID+1;
                            
                            % Precompute RT matrices if joint are not being
                            % optimized
                            %if ~chains.joint
                            
%                             if ~ismember(chain1, {'rightFinger', 'leftFinger'})
%                                 dh=DH.(chain1);
%                                 dh(:,6)=dh(:,6)+angles.(chain1)';
%                                 matrices.(chain1)=dhpars2tfmat(dh);
%                             else
%                                 dh=DH.([name1, 'Arm']);
%                                 dh(:,6)=dh(:,6)+angles.([name1, 'Arm'])';
%                                 matrices.([name1, 'Arm'])=dhpars2tfmat(dh);
%                             end
%                             
%                             if ~ismember(chain2, {'rightFinger', 'leftFinger'})
%                                 dh=DH.(chain2);
%                                 dh(:,6)=dh(:,6)+angles.(chain2)';
%                                 matrices.(chain2)=dhpars2tfmat(dh);
%                             else
%                                 dh=DH.([name2, 'Arm']);
%                                 dh(:,6)=dh(:,6)+angles.([name2, 'Arm'])';
%                                 matrices.([name2, 'Arm'])=dhpars2tfmat(dh);
%                             end

                            % Torso is computed everytime to prevent
                            % error in getTF
                            matrices.torso=eye(4);
                            
                            datasetLocal.rtMat=[datasetLocal.rtMat;matrices];
                            
                            %Just for visualization
                            datasetLocal.cops=[datasetLocal.cops;taxelStruct.(strcat('s',num2str(index))).cops{i}];
                            datasetLocal.cop=[datasetLocal.cop;taxelStruct.(strcat('s',num2str(index))).cop{i}];
                            datasetLocal.newTaxelsNA=[datasetLocal.newTaxelsNA;taxelStruct.(strcat('s',num2str(index))).newTaxelsNA{i}];
                            datasetLocal.newTaxels=[datasetLocal.newTaxels;taxelStruct.(strcat('s',num2str(index))).newTaxels{i}];
                        end
                    end

                end
                %if there were more than X (10) activations on one
                %triangle, assign them to the global dataset
                if size(datasetLocal.point,1)>0
                    dataset.refPoints=[dataset.refPoints;datasetLocal.refPoints];
                    dataset.point=[dataset.point;datasetLocal.point];
                    dataset.joints=[dataset.joints;datasetLocal.joints];
                    dataset.frame=[dataset.frame;datasetLocal.frame];
                    dataset.frame2=[dataset.frame2;datasetLocal.frame2];
                    dataset.pose=[dataset.pose;datasetLocal.pose];
                    dataset.rtMat=[dataset.rtMat;datasetLocal.rtMat];
                    dataset.mins=[dataset.mins;datasetLocal.mins];
                    dataset.difs=[dataset.difs;datasetLocal.difs];
                    dataset.cops=[dataset.cops;datasetLocal.cops];
                    dataset.cop=[dataset.cop;datasetLocal.cop];
                    dataset.newTaxelsNA=[dataset.newTaxelsNA;datasetLocal.newTaxelsNA];
                    dataset.newTaxels=[dataset.newTaxels;datasetLocal.newTaxels];
                end
        end
        dataset.avg=mean(dataset.mins);
        dataset.avgDifs=mean(dataset.difs);
        % Assign dataset into output datasets
        datasets.selftouch{name}=dataset;
    end
    % Assigning datasets to the right groups
    %datasets.selftouch=datasets;
    %datasets = {datasets,{},{},{}};
end