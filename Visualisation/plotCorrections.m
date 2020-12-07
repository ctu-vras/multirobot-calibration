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
%                       - 'units' - 'm' or 'mm'
%                                 - Default: units from the calibration

    % Argument parser
    p=inputParser;
    addRequired(p,'folder');
    addParameter(p,'noiseLevel',0);
    addParameter(p,'log',0);
    addParameter(p,'units','x', @(x) any(validatestring(x,{'m','mm'})));
    
    parse(p,folder,varargin{:});
    
    % get values from parser
    noiseLevel=p.Results.noiseLevel;
    symLog=p.Results.log;
    units=p.Results.units;
	% load saved variables
    corrections=load(['Results/',folder,'/corrections.mat']);
    corrections=corrections.corrs_dh;
    info = load(['Results/',folder,'/info.mat']);
    robot=info.rob;
    whitelist=info.whitelist;
    
    % assigning string based on const
    if strcmp(units,'m')
        coef=1;
    elseif strcmp(units,'mm')
        coef=1000;
    else
        coef = info.optim.unitsCoef;
        units = info.optim.units;
    end
    
    fnames=fieldnames(corrections);
    
    for name = 1:size(fnames,1)
        whitelist.(fnames{name}) = double(whitelist.(fnames{name}));
    end
    [whitelist, ~] = padVectors(whitelist, 1);
    
    [corrections, ~] = padVectors(corrections);
    for name = 1:size(fnames,1)
        whitelist.(fnames{name}) = logical(whitelist.(fnames{name}));
    end
    
    params={'x/a','y/d','z','$\alpha$','$beta$','$\theta$'};
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
           col=mod(idx,6)+1; 
           % get rows idxs
           row=floor(idx/6)+1;  
           values=[];
           xt={};
           
           % for each DH parameter
           for i=1:6
              % for every parameter, where column index is 'i' (1-6)
              for j=row(col==i)'
                  % assign values 
                  if(i > 3)
                      values=[values,corrections.(fnames{name})(j,i,:,noiseLevel+1)];
                  else
                      values=[values,corrections.(fnames{name})(j,i,:,noiseLevel+1).*coef];
                  end
                  % get name of parameter
                  xt{end+1}=[joints{j}.name,' ',params{i}];
              end
              % if i%3==0 (3,6) show figure
              if mod(i,3)==0 && ~isempty(values)
                   values=permute(values,[3,2,1]);
                   fig=figure();
                   bp=axes();
                   if(size(values,1) == 1)
                        bplot(repmat(values,2,1));
                   else
                        bplot(values);
                   end
                   set(bp,'Xtick', 1:size(values,2),'xticklabel',xt)
                   xlim([0.5,0.5+size(values,2)])
                   xtickangle(bp,-15)
                   bp.XAxis.TickLabelInterpreter = 'latex';
                   bp.YAxis.TickLabelInterpreter = 'latex';
                   values=[];
                   xt={};
                   xlabel(bp,'Joints')
                   % lengths
                   if i==3
                    ylabel(bp,['Corrections [',units,']']);
                    if symLog
                        bisymlog('y', 0, 0, bp);
                    end
                   % angles
                   else
                    ylabel(bp,'Corrections [rad]');
                   
                    if symLog
                        bisymlog('y',-3, 0, bp);
                    end
                   end
                   title(bp,['Corrections of ',fnames{name}])
                   grid(bp,'on');
                   set(findall(gcf, '-property', 'FontSize'), 'FontSize', 16)
              end
           end
        end
    end
    
end

