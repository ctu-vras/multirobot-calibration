function visualizeActivatedTaxels(varargin)
    % VISUALIZEACTIVATEDTAXELS shows activated taxels on all chains and 
    % number of actiated taxels/triangles for given datasets.
    %   INPUT - datasetNames - 1xN cellArray of strings
    %                        - e.g. {'rightArm_torso'}
    close all;
    varargin=varargin{1};
    if length(varargin)==1
        alt='';
        datasetsNames=varargin;
    else
        if strfind(varargin{end},'Alt')
            alt=varargin{end};
            datasetsNames=varargin{1:end-1};
        else
            alt='';
            datasetsNames=varargin;
        end    
    end
    for name=1:length(datasetsNames)
        % get chain names from dataset name
        spl=strsplit(datasetsNames{name},'_');
        chain1=spl{1};
        chain2=spl{2};
        %import points in local frames
        firstLocal = importdata(strcat('Dataset/Points/',chain1,'.txt'),' ',4);
        secondLocal = importdata(strcat('Dataset/Points/',chain2,'.txt'),' ',4);
        %load daatset
        data=load(strcat('Dataset/Datasets/',datasetsNames{name})); 
        % put first taxels into the array
        activated1Idx=data.(chain1)(1).activatedUn(:,4);    
        activated2Idx=data.(chain2)(1).activatedUn(:,4);
        for i=2:size(data.(chain1),1)
           for j=1:size(data.(chain1)(i).activatedUn(:,4),1)
                %if taxel Id is not already in activated, add them
                if ~ismember(data.(chain1)(i).activatedUn(j,4),activated1Idx)
                    activated1Idx=[activated1Idx;data.(chain1)(i).activatedUn(j,4)];
                end
           end
           for j=1:size(data.(chain2)(i).activatedUn(:,4),1)
                 if ~ismember(data.(chain2)(i).activatedUn(j,4),activated2Idx)
                    activated2Idx=[activated2Idx;data.(chain2)(i).activatedUn(j,4)];
                end
           end

        end
        
        numTri1=0;
        nonActivated1=[];
        activated1=[];
        actTri1=zeros(1,32);
        for triangle=0:31
            % if any activated taxel on the triangle
            if any(any(firstLocal.data(triangle*12+1:triangle*12+12,1:3)))
                numTri1=numTri1+1;
                for i=1:12
                    index=triangle*12+i;
                    % if not (0,0,0)
                    if all(firstLocal.data(index,1:3))
                        % if not in activated => add point to non-activated
                        if ~ismember(index-1,activated1Idx)
                            nonActivated1=[nonActivated1;firstLocal.data(index,:)];
                        % else add to activated and set triangle as active
                        else 
                            actTri1(triangle+1)=1;
                            activated1=[activated1;firstLocal.data(index,:)];
                        end
                    end
                end
            end
        end
        
        numTri2=0;
        actTri2=zeros(1,32);
        nonActivated2=[];
        activated2=[];
        for triangle=0:31
            if any(any(secondLocal.data(triangle*12+1:triangle*12+12,1:3)))
                numTri2=numTri2+1;
                for i=1:12
                    index=triangle*12+i;
                    if all(secondLocal.data(index,1:3))
                        if ~ismember(index-1,activated2Idx)
                            nonActivated2=[nonActivated2;secondLocal.data(index,:)];
                        else 
                            actTri2(triangle+1)=1;
                            activated2=[activated2;secondLocal.data(index,:)];
                        end
                    end
                end
            end
        end
        
        %% Chain1
        a=figure('Name',chain1);
        hold on
        scatter3(nonActivated1(:,1),nonActivated1(:,2),nonActivated1(:,3),'red');
        scatter3(activated1(:,1),activated1(:,2),activated1(:,3),'filled','red');
        view([105 30]);
        axis equal
%         savefig(a,strcat(robot.home,'/../Visualization/Figs/FIG/New/',robot.optProperties.name,datName,'part1Act.fig'));
%         saveas(a,strcat(robot.home,'/../Visualization/Figs/PNG/New/',robot.optProperties.name,datName,'part1Act.png'));
%         saveas(a,strcat(robot.home,'/../Visualization/Figs/EPS/New/',robot.optProperties.name,datName,'part1Act'),'epsc');
        %% Chain2
        a=figure('Name',chain2);
        hold on
        scatter3(nonActivated2(:,1),nonActivated2(:,2),nonActivated2(:,3),'red');
        scatter3(activated2(:,1),activated2(:,2),activated2(:,3),'filled','red');
        view([90 0]);
        axis equal
        axis tight
%         savefig(a,strcat(robot.home,'/../Visualization/Figs/FIG/New/',robot.optProperties.name,datName,'part2Act.fig'));
%         saveas(a,strcat(robot.home,'/../Visualization/Figs/PNG/New/',robot.optProperties.name,datName,'part2Act.png'));
%         saveas(a,strcat(robot.home,'/../Visualization/Figs/EPS/New/',robot.optProperties.name,datName,'part2Act'),'epsc');
        %% Used taxels
        a=figure();
        bar([size(activated1,1)/(size(activated1,1)+size(nonActivated1,1))*100,size(activated2,1)/(size(activated2,1)+size(nonActivated2,1))*100]);
        set(gca,'xticklabel',{chain1,chain2});
        title('Number of used taxels')
        xlabel('Chains')
        ylabel('Used taxels [%]')
        
        %% Used triangles
        a=figure();
        bar([size(find(actTri1),2)/numTri1*100,size(find(actTri2),2)/numTri2*100]);
        set(gca,'xticklabel',{chain1,chain2});
        title('Number of used triangles')
        xlabel('Chains')
        ylabel('Used triangles [%]')
    end
end