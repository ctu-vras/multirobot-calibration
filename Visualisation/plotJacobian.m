function plotJacobian(robot, whitelist, jacobians, titles)
%PLOTJACOBIAN Function for plotting jacobians
%INPUT - robot - Robot object
%      - whitelist - whitelist structure to gain the parameters names
%      - jacobians - cell array of jacobians
%      - titles - subplot titles
    %% xt contains the parameters names
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
    %% choose subplots grid
    jacobians = reshape(jacobians, [],1,1);
    count = length(jacobians);
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
    h = figure();
    hold on;
    %% plot normalized jacobians
    for j= 1:length(jacobians)
        subplot(rows,cols,j);
        maxs = max(max(abs(jacobians{j})));
        maxs(maxs == 0) = 1;
        jac = jacobians{j}./maxs;
        boxplot(jac)
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

