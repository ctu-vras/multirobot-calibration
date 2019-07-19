function getTaxelDistances(robot, datasetsNames)
    DH=robot.structure.DH;
    DH.torso=[0,0,0,0];
    close all;
    for name=1:length(datasetsNames)
        spl=strsplit(datasetsNames{name},'_');
        chain1=spl{1};
        chain2=spl{2};
        taxelStruct=prepareData(robot,datasetsNames{name},chain1,chain2,DH);
        
        dataX=[];
        dataY=[];
        xTicks=[];
        xValue=1;
        xTic=[];

        dataXT=[];
        dataYT=[];
        xValueT=1;
        xTicksT=[];
        xTicT=[];
        activated=false;
        for triangleId=0:31
            for taxelId=1:12
                index=triangleId*12+taxelId;
                if size(taxelStruct.(strcat('s',num2str(index))).distances,1)>=5
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
        a=figure();
        scatter(dataX,dataY)
        set(gca,'xtick',xTic);
        set(gca,'xticklabel',xTicks);
        xtickangle(90);
        grid on;
        xlabel('Taxel numbers')
        ylabel('Error [mm]')
        title('Error distribution for taxels')
        % savefig(a,strcat(home,'/../Visualization/Figs/FIG/New/',name,'Taxels.fig'));
        % saveas(a,strcat(home,'/../Visualization/Figs/PNG/New/',name,'Taxels.png'));
        % saveas(a,strcat(home,'/../Visualization/Figs/EPS/New/',name,'Taxels'),'epsc');
        b=figure();
        scatter(dataXT,dataYT)
        set(gca,'xtick',xTicT);
        set(gca,'xticklabel',xTicksT);
        grid on;
        xlabel('Triangle numbers')
        ylabel('Error  [mm]')
        title('Error distribution for triangles')
        % savefig(b,strcat(home,'/../Visualization/Figs/FIG/New/',name,'Triangles.fig'));
        % saveas(b,strcat(home,'/../Visualization/Figs/PNG/New/',name,'Triangles.png'));
        % saveas(b,strcat(home,'/../Visualization/Figs/EPS/New/',name,'Triangles'),'epsc');
    end
end