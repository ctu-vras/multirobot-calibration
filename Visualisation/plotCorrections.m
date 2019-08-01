function plotCorrections(folder, varargin)
% PLOTCORRECTIONS shows two plots for each 'group'. One with length (a,d)
% and one with angles (alpha, theta) of corrections from given folder.
%   INPUT - folder - string name of folder with results
%         - varargin - Uses MATLABs argument parser, with these pairs:
%                       - 'noiseLevel' - int, determines which perturbation
%                                        level to use
%                                      - Default: 0
%                       - 'log' - 1/0 to use logarithmic scale
%                               - Default: 1
%                       - 'const' - 1 or 1000, to use m or mm
%                                 - Default: 1

    % Argument parser
    p=inputParser;
    addRequired(p,'folder');
    addParameter(p,'noiseLevel',0);
    addParameter(p,'log',1);
    addParameter(p,'const',1, @(x) ismember(x,[1,1000]));
    parse(p,folder,varargin{:});
    
    % get values from parser
    noiseLevel=p.Results.noiseLevel;
    symLog=p.Results.log;
    const=p.Results.const;
    % assing string based on const
    if const==1
        constName='m';
    elseif const==1000
        constName='mm';
    end
	close all
    % load saved variables
    corrections=load(['results/',folder,'/corrections.mat']);
    corrections=corrections.corrs_dh;
    info = load(['results/',folder,'/info.mat']);
    robot=info.rob;
    whitelist=info.whitelist;
    
    fnames=fieldnames(corrections);
    params={'a','d','$\alpha$','$\theta$'};
    % iterate over all 'groups'
    for name=1:length(fnames)
        % if any parameter from 'group' was optimized
        if any(any(whitelist.(fnames{name})))
           % find joint by it's group
           joints=robot.findJointByGroup(fnames{name});
           % find indexes of '1' in whitelist and substract 1 to get values
           % from 0 to n-1
           idx=find(whitelist.(fnames{name})')-1;
           % get columns idxs
           col=mod(idx,4)+1; 
           % get rows idxs
           row=floor(idx/4)+1;  
           values=[];
           xt={};
           
           % for each DH parameter
           for i=1:4
              % for every parameter, where column index is 'i' (1-4)
              if i>2
                  const=1;
              end
              for j=row(col==i)'
                  % assign values 
                  values=[values,corrections.(fnames{name})(j,i,:,noiseLevel+1).*const];
                  % get name of parameter
                  xt{end+1}=[joints{j}.name,' ',params{i}];
              end
              % if i%2==0 (2,4) show figure
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
                   % lengths
                   if i==2
                    ylabel(bp,['Corrections [',constName,']']);
                    if symLog
                        symlog(bp,'y');
                    end
                   % angles
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

