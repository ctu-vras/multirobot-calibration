function getTaxelDistances(robot, chains, varargin)
    % GETTAXELDISTANCES shows distribution of distances between
    % taxels/triangles.
    %   INPUT - robot - instance of @Robot class
    %         - datasetsNames - 1xN cellArray of strings
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
        taxelStruct=prepareData(robot,datasetsNames{name},chain1,chain2,DH,alt,chains);
        
        %Allocate matrices
        dataX=[]; %X index
        dataY=[]; % Y index
        xTicks=[]; % X tick names
        xValue=1; % x index
        xTic=[]; %x tick values

        dataXT=[];
        dataYT=[];
        xValueT=1;
        xTicksT=[];
        xTicT=[];
        activated=false;
        % iterate over all triangle
        for triangleId=0:31
            for taxelId=1:12
                index=triangleId*12+taxelId;
                % if more than X activations on one taxel
                if size(taxelStruct.(strcat('s',num2str(index))).distances,1)>=1
                    for j=1:size(taxelStruct.(strcat('s',num2str(index))).distances,1)
                       dataX=[dataX;xValue];
                       dataY=[dataY;taxelStruct.(strcat('s',num2str(index))).distances(j)];
                       dataXT=[dataXT,xValueT];
                       dataYT=[dataYT,taxelStruct.(strcat('s',num2str(index))).distances(j)];
                       activated=true;
                    end
                    xTicks=[xTicks;index-1];
                    xTic=[xTic;xValue];
                    xValue=xValue+1;
                end
            end
            if activated
                xTicT=[xTicT;xValueT];
                xValueT=xValueT+1;
                xTicksT=[xTicksT;triangleId];
                activated=false;
            end
        end
        a=figure('Name', [datasetsNames{name}, ' taxels']);
        scatter(dataX,dataY)
        set(gca,'xtick',xTic);
        set(gca,'xticklabel',xTicks);
        xtickangle(90);
        grid on;
        xlabel('Taxel numbers')
        ylabel('Error [m]')
        title('Error distribution for taxels')
        % savefig(a,strcat(home,'/../Visualization/Figs/FIG/New/',name,'Taxels.fig'));
        % saveas(a,strcat(home,'/../Visualization/Figs/PNG/New/',name,'Taxels.png'));
        % saveas(a,strcat(home,'/../Visualization/Figs/EPS/New/',name,'Taxels'),'epsc');
        b=figure('Name', [datasetsNames{name}, ' triangles']);
        scatter(dataXT,dataYT)
        set(gca,'xtick',xTicT);
        set(gca,'xticklabel',xTicksT);
        grid on;
        xlabel('Triangle numbers')
        ylabel('Error  [m]')
        title('Error distribution for triangles')
        % savefig(b,strcat(home,'/../Visualization/Figs/FIG/New/',name,'Triangles.fig'));
        % saveas(b,strcat(home,'/../Visualization/Figs/PNG/New/',name,'Triangles.png'));
        % saveas(b,strcat(home,'/../Visualization/Figs/EPS/New/',name,'Triangles'),'epsc');
    end
end