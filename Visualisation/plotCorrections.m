function plotCorrections(robot, folder, noiseLevel, symLog)
    if nargin~=4
        symLog=1;
    end
	close all
    corrections=load(['results/',folder,'/corrections.mat']);
    corrections=corrections.corrs_dh;
    info = load(['results/',folder,'/info.mat']);
    whitelist=info.whitelist;
    fnames=fieldnames(corrections);
    params={'a','d','$\alpha$','$\theta$'};
    for name=1:length(fnames)
        if any(any(whitelist.(fnames{name})))
           joints=robot.findJointByGroup(fnames{name});
           idx=find(whitelist.(fnames{name})')-1;
           col=mod(idx,4)+1;      
           row=floor(idx/4)+1;  
           values=[];
           xt={};
           
           for i=1:4
              for j=row(col==i)'
                  values=[values,corrections.(fnames{name})(j,i,:,noiseLevel+1)];
                  xt{end+1}=[joints{j}.name,' ',params{i}];
              end
              if mod(i,2)==0
                   values=permute(values,[3,2,1]);
                   fig=figure();
                   bp=axes();
                   boxplot(values);
                   set(bp,'xticklabel',xt)
                   xtickangle(bp,90)
                   bp.XAxis.TickLabelInterpreter = 'latex';
                   bp.YAxis.TickLabelInterpreter = 'latex';
                   values=[];
                   xt={};
                   xlabel(bp,'Joints')
                   if i==2
                    ylabel(bp,'Corrections [m]');
                    if symLog
                        symlog(bp,'y');
                    end
                   else
                    ylabel(bp,'Corrections [rad]');
                    if symLog
                        symlog(bp,'y',-3);
                    end
                   end
                   title(bp,['Corrections of ',fnames{name}])
                   grid(bp,'on');
                   
              end
           end

        end
    end
end

