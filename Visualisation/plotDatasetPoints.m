function plotDatasetPoints(robot,datasets)
    %PLOTDATASETPOINTS - plots robot model with all gathered points from
    %                    dataset
    %   INPUT - robot - instance of @Robot class
    %         - datasets - structure of datasets

    datasetsCell = struct2cell(datasets);
    datasetsCell = horzcat(datasetsCell{:});
    for dataset = datasetsCell
        figure()
        fig = robot.showModel('showText', 0);
        set(0, 'CurrentFigure', fig);
        hold on;
        [dh_pars, ~] = padVectors(robot.structure.DH);
        arm1 = getPoints(robot, dh_pars, dataset{1}, false);    
        scatter3(arm1(1,:), arm1(2,:), arm1(3,:), 'g', 'filled', 'MarkerEdgeColor', 'k');
    end
end

