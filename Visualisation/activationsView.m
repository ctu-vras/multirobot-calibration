function activationsView(robot,datasets,varargin)  
    % ACTIVATIONSVIEW shows moving model of the robot with option to show
    % statistics and skin. Shows one fig for each dataset. Activations can
    % be changed with 'right' and 'left' keys on the keyboard.
    %   INPUT - robot - instance of @Robot class
    %         - datasets - 1xN cellArray of structs
    %                      e.g. {dataset1} or {dataset1,dataset2}...
    %         - varargin - Uses MATLABs argument parser, with these pairs:
    %                       - 'skin' - 1/0 to visualize skin (NAO only)
    %                                - Default: 0
    %                       - 'info' - 1/0 to show statistics (NAO only)
    %                                - Default: 0
    
    close all;
    % Argument parser
    p=inputParser;
    addRequired(p,'robot');
    addRequired(p,'datasets');
    addParameter(p,'skin',0);
    addParameter(p,'info',0);
    parse(p,robot,datasets,varargin{:});
    %% First fig of each dataset
    for dataset=datasets
        idx=1;
        showFig(robot,idx,dataset{1},p.Results);
    end

end
%% Fig show
function showFig(robot,idx,dataset,parser)
    fnames=fieldnames(robot.structure.kinematics);
    fnames(contains(fnames,'torso') | contains(fnames,'Skin') |...
      contains(fnames,'Middle')...
    | contains(fnames,'Index') | contains(fnames,'Thumb') | contains(fnames,'Markers')...
    | contains(fnames,'dummy') )= [];
    ang=cell(1,length(fnames));
    % Get angles from dataset in correct format for 'showModel'
    for name=1:length(fnames)
        if isfield(dataset.joints(idx),fnames{name}) 
            ang{name}=dataset.joints(idx).(fnames{name});
        else
            ang{name}=zeros(1, size(robot.structure.kinematics.((fnames{name})),1));
        end
    end
    % check dataset name and add empty string if missing
    if ~isfield(dataset,'name')
        dataset.name='';
    end
    
    % Show model in given configuration
    robot.showModel(ang,'figName',dataset.name);
    
    %If skin
    if parser.skin
        % show skin and color activated taxels, selected COP and all cops
        % with different color for each chain
        x=1;
        scatter3(dataset.newTaxelsNA{idx,1}(:,1).*x,dataset.newTaxelsNA{idx,1}(:,2).*x,dataset.newTaxelsNA{idx,1}(:,3).*x,'red')
        scatter3(dataset.newTaxels{idx,1}(:,1).*x,dataset.newTaxels{idx,1}(:,2).*x,dataset.newTaxels{idx,1}(:,3).*x,'filled','red')
        scatter3(dataset.newTaxelsNA{idx,2}(:,1).*x,dataset.newTaxelsNA{idx,2}(:,2).*x,dataset.newTaxelsNA{idx,2}(:,3).*x,'blue')
        scatter3(dataset.newTaxels{idx,2}(:,1).*x,dataset.newTaxels{idx,2}(:,2).*x,dataset.newTaxels{idx,2}(:,3).*x,'filled','blue')
        scatter3(dataset.cops{idx,1}(:,1).*x,dataset.cops{idx,1}(:,2).*x,dataset.cops{idx,1}(:,3).*x,'filled','black')
        scatter3(dataset.cops{idx,2}(:,1).*x,dataset.cops{idx,2}(:,2).*x,dataset.cops{idx,2}(:,3).*x,'filled','black')
        scatter3(dataset.cop{idx,1}(:,1).*x,dataset.cop{idx,1}(:,2).*x,dataset.cop{idx,1}(:,3).*x,150,'red','filled')
        scatter3(dataset.cop{idx,2}(:,1).*x,dataset.cop{idx,2}(:,2).*x,dataset.cop{idx,2}(:,3).*x,150,'blue','filled')
    end
    
    %If info
    if parser.info
        %Get chains names
        C=strsplit(dataset.name,'_');
        chain1=C{1};
        chain2=C{2};

        %Get information from dataset
        dist=dataset.mins(idx);
        activatedTaxels_1=size(dataset.newTaxels{idx,1},1);
        activatedTaxels_2=size(dataset.newTaxels{idx,2},1);
        average=dataset.avg;
        NoCops_1=size(dataset.cops{idx,1},1);
        NoCops_2=size(dataset.cops{idx,2},1);
        difs.x=dataset.difs(idx,1);
        difs.y=dataset.difs(idx,2);
        difs.z=dataset.difs(idx,3);
        %Print in table to figure
        txt = sprintf('Activation: %d \n COPs distance: %f \n Activated taxels: \n \t %d on %s \n \t %d on %s \n Average distance: %f \n Number of COPs: \n \t %d on %s \n \t %d on %s \n Xdif: %f \n Ydif: %f \n Zdif: %f \n ',...
        idx, dist,activatedTaxels_1,chain1,...
        activatedTaxels_2,chain2,average,...
        NoCops_1,chain1,NoCops_2,chain2,...
        difs.x,difs.y,difs.z);

        dim=[0 0 1 1];
        annotation('textbox',dim,'String',txt,'FitBoxToText','on')
    end
    % find correct figure
    title(['Point ', num2str(idx)]) 
    f = findobj( 'Type', 'Figure', 'Name', dataset.name);
    %Set callback to keyboard keys
    set(f,'KeyPressFcn',{@key_press,robot, idx, dataset,parser});
end

%% Key pressing
function key_press(source,event,robot, idx, dataset,parser)
    k=event.Key;
    
    % right = forward
    if strcmp(k,'rightarrow')
        % find figure for given dataset
        f = findobj( 'Type', 'Figure', 'Name', dataset.name);
        % clear figure
        clf(f)
        % add index
        idx=idx+1;
        
        % if idx>number of activation => go to start
        if idx>size(dataset.point,1)
           idx=1;
        end 
        
        showFig(robot, idx, dataset,parser);
    end
    if strcmp(k,'leftarrow')
        f = findobj( 'Type', 'Figure', 'Name', dataset.name);
        clf(f)
        idx=idx-1;
        % if idx<1 => go to end
        if idx<1
           idx=size(dataset.point,1);
        end 
        showFig(robot, idx, dataset,parser);
    end
end

