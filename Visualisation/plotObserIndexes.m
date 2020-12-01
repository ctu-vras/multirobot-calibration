function plotObserIndexes(folder)
%PLOTJACOBIAN Function for plotting jacobians
%INPUT - robot - Robot object
%      - whitelist - whitelist structure to gain the parameters names
%      - jacobians - cell array of jacobians
%      - titles - subplot titles
    info = load(['Results/',folder,'/info']);
    obsIndexes = cell2mat(permute(struct2cell(repmat(info.obsIndexes,1,4)), [2,3,1]));
    figure();
    titles = fieldnames(info.obsIndexes);
    ticks = cell(1, size(obsIndexes,2));     
    perts = find(info.optim.pert == 1);
    perts = [1,5,10,12];
    if (info.optim.skipNoPert) 
        index = 1;
    else
        ticks{1} = 'no pert';  
        index = 2;
    end
    for i = perts
        ticks{index} = ['pert ', num2str(i)];
        index = index+1;
    end
    hold on;
    for j= 1:4
        subplot(2,2,j);
        bplot(obsIndexes(:,:,j));
        set(gca, 'Xtick', 1:size(obsIndexes,2), 'XTickLabel',ticks, 'FontSize',16)
        title(titles(j));
        xlim([0.5, size(obsIndexes,2)+0.5])
        bp = gca;
        xtickangle(30)
        ylabel('Value [-]','FontSize',15);
        bp.XAxis.FontSize = 15;
        set(findobj(gca,'Type','text'),'FontSize')
        grid on;
    end
end

