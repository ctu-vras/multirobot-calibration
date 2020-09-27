function showNaoSkin()
    % SHOWNAOSKIN shows skin for NAO robot with triangles and taxels
    % indexes

    close all
    points = struct();
    indexes = struct();
    for part={'leftArm','rightArm', 'torso','head'} %,
        part=part{1};
        file = fopen(strcat('Dataset/Points/',part,'.txt'));
        line = 4;
        C = textscan(file,'%s',1,'delimiter','\n', 'headerlines',line-1);
        spec = '%f %f %f %f %f %f';
        points.(part) = fscanf(file, spec, [6 Inf])';
        indexes.(part) = any(points.(part)~=[0,0,0,0,0,0], 2);

    end

    screen_size = get(0,'ScreenSize');
    pc_width  = screen_size(3);
    pc_height = screen_size(4);

    positions.torso = [pc_width/3,0,550,400];
    positions.head = 0;
    positions.rightArm = [0,pc_height/3,550,400];
    positions.leftArm = [pc_width,pc_height/3,550,400];

    for part={'leftArm','rightArm', 'torso','head'} %'torso','head',
        part = part{1};
        fig = figure('Name', part);
        hold on;
        if ~strcmp(part,'head')
            set(fig, 'Position', positions.(part));
        end

        all_idxs = 1:size(points.(part),1);
        idxs = all_idxs(indexes.(part));

        middles = fix((idxs-1)/12);
        idxs = mod(idxs-1,12)==3;
        middles = middles(idxs);

        idxs = indexes.(part) & mod(all_idxs',12)==4;

        text(points.(part)(idxs,1), points.(part)(idxs, 2),...
                points.(part)(idxs, 3), num2str(middles'),'VerticalAlignment','middle', ...
                'HorizontalAlignment', 'center', 'FontSize', 25);

        scatter3(points.(part)(indexes.(part),1),...
            points.(part)(indexes.(part),2), points.(part)(indexes.(part),3),300);

        %idxs = mod(all_idxs-1,12); % show as 0-11 for each triangle
        idxs=all_idxs-1; % show as 0-383
        text(points.(part)(indexes.(part),1), points.(part)(indexes.(part),2),...
                points.(part)(indexes.(part),3),num2str(idxs(indexes.(part))'),'VerticalAlignment','middle', ...
                'HorizontalAlignment', 'center');

        view([90 0]);
        axis equal
        grid off
    end
end