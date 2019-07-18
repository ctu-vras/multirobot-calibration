function plotErrorResiduals( computed_points, real_points )
%PLOT Summary of this function goes here
%   Detailed explanation goes here
    real_points = real_points*1000;
    computed_points = computed_points*1000;
    
    figure()
    subplot(2,1,1)     
    scatter(computed_points(1,:)-real_points(1,:), computed_points(2,:)-real_points(2,:))
    xlabel('error in X [mm]')
    ylabel('error in Y [mm]')
    title('Residuals of end effector position error')
    subplot(2,1,2)
    scatter(computed_points(2,:)-real_points(2,:), computed_points(3,:)-real_points(3,:))
    xlabel('error in Y [mm]') 
    ylabel('error in Z [mm]')
    
    figure()
    subplot(2,1,1)
    quiver(real_points(1,:), real_points(2,:), computed_points(1,:)-real_points(1,:), computed_points(2,:)-real_points(2,:), 1, 'Color', 'b');
    xlabel('X [mm]')
    ylabel('Y [mm]')
    title('End effector position and residuals of error')
    subplot(2,1,2)
    quiver(real_points(2,:), real_points(3,:), computed_points(2,:)-real_points(2,:), computed_points(3,:)-real_points(3,:), 1, 'Color', 'b');
    xlabel('Y [mm]')
    ylabel('Z [mm]')
    
    figure()
    subplot(2,1,1)
    quiver(computed_points(1,:)-real_points(1,:), computed_points(2,:)-real_points(2,:), 1, 'Color', 'b');
    xlabel('X [mm]')
    ylabel('Y [mm]')
    title('Residuals of end effector position error')
    subplot(2,1,2)
    quiver(computed_points(2,:)-real_points(2,:), computed_points(3,:)-real_points(3,:), 1, 'Color', 'b');
    xlabel('Y [mm]')
    ylabel('Z [mm]')
end

