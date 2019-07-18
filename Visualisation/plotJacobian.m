function [ output_args ] = plotJacobian(robot, whitelist, Jacobians, titles)
%PLOTJACOBIAN Summary of this function goes here
%   Detailed explanation goes here

%     h = figure('Position', [10 10 2400 1600]);
    hold on;
    fnames=fieldnames(robot.structure.DH);
    params={'a','d','$\alpha$','$\theta$'};
    xt = {};
    for name=1:length(fnames)
        if any(any(whitelist.(fnames{name})))
           joints=robot.findJointByGroup(fnames{name});
           idx=find(whitelist.(fnames{name})')-1;
           col=mod(idx,4)+1;
           row=floor(idx/4)+1;
           for i=1:size(whitelist.(fnames{name}),1)
              for j=col(row==i)'
                  xt{end+1}=[joints{i}.name,' ',params{j}];
              end
           
           end
        end  
    end
    Jacobians = reshape(Jacobians, [],1,1);
    
    count = length(Jacobians);
    if(count < 4)
        rows = count;
        cols = 1;
    elseif(count < 5)
       rows = 2;
       cols = 2; 
    elseif(count < 7)
        rows = 3;
        cols = 2;
    elseif(count < 9)
        rows = 4;
        cols = 2;
    elseif(count < 10)
        rows = 3;
        cols = 3;
    elseif(count < 13)
        rows = 4;
        cols = 3;
    else
        rows = 4;
        cols = 4;
    end
    
    for j= 1:length(Jacobians)
        subplot(rows,cols,j);
        maxs = max(max(abs(Jacobians{j})));
        maxs(maxs == 0) = 1;
        Jac = Jacobians{j}./maxs;
        boxplot(Jac)
        set(gca,'XTickLabel',xt, 'FontSize',16)
        ylim([-1,1])
        bp = gca;
        xtickangle(90)
        bp.XAxis.TickLabelInterpreter = 'latex';
        ylabel('$\frac{\partial X_i}{\partial \phi_j}$', 'Interpreter', 'latex','FontSize',15);

        bp.XAxis.FontSize = 15;
        set(findobj(gca,'Type','text'),'FontSize')
        if(iscell(titles))
            title(titles{j})
        else
            title(titles)
        end
        grid on;
    end
end

