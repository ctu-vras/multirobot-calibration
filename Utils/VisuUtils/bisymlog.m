function bisymlog(ax, logc, useExp, axes)
    %BISYMLOG - Bi-Symmetric Log transformation
    %   INPUT - ax - matlab axis to be changed
    %         - logc - exponent of logarithm
    %         - useExp - 0/1, show as 10^x
    %         - axes - matlab axes
    % Webber, John. (2013). A bi-symmetric log transformation for wide-range data.
    % Measurement Science and Technology. 24. 027001. 10.1088/0957-0233/24/2/027001.


    % Copyright (C) 2019-2021  Jakub Rozlivek and Lukas Rustler
    % Department of Cybernetics, Faculty of Electrical Engineering, 
    % Czech Technical University in Prague
    %
    % This file is part of Multisensorial robot calibration toolbox (MRC).
    % 
    % MRC is free software: you can redistribute it and/or modify
    % it under the terms of the GNU Lesser General Public License as published by
    % the Free Software Foundation, either version 3 of the License, or
    % (at your option) any later version.
    % 
    % MRC is distributed in the hope that it will be useful,
    % but WITHOUT ANY WARRANTY; without even the implied warranty of
    % MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    % GNU Lesser General Public License for more details.
    % 
    % You should have received a copy of the GNU Leser General Public License
    % along with MRC.  If not, see <http://www.gnu.org/licenses/>.
    
    
    if (nargin < 4)
        axes = gca;
    end
    C = 10^logc;
       
    objs = reshape(findobj(axes),1,[]);
    for obj=objs
        for ch=ax
            if(isprop(obj, [ch,'Data']))
                y = obj.YData;
                x = obj.XData;
                z = obj.ZData;
                c = [];
                if (isprop(obj, 'CData'))
                    c = obj.CData;
                end
                typ = obj.Type;
                if (ch == 'x')
                    x = sign(x).*log10(1+abs(x)/C);
                elseif(ch == 'y')
                    y = sign(y).*log10(1+abs(y)/C);
                elseif(ch == 'z')
                    z = sign(z).*log10(1+abs(z)/C);
                end
                if(strcmpi(typ,'scatter'))
                    if(isempty(z))
                        scatter(x,y);
                    else
                        scatter3(x,y,z);
                    end
                else
                    if(~isempty(c))
                        set(obj,'XData',x,'YData',y, 'ZData', z, 'CData', c);
                    else
                        set(obj,'XData',x,'YData',y, 'ZData', z);
                    end
                end
            end
        end
    end
    
    for ch=ax
        set(axes, [ch, 'Scale'], 'linear')
        if strcmpi(get(axes,[ch,'LimMode']),'manual')
            axlim = get(axes,[ch,'Lim']);
            axlim = sign(axlim).*log10(1+abs(axlim)/C);
            set(axes,[ch,'Lim'],axlim)
        end

        expo = max(get(axes,[ch,'Lim']));
        expo = logc:ceil(expo)+1; 
        ticks = 10.^expo;   
        expoNeg = min(get(axes,[ch,'Lim']));
        if(expoNeg < 0) 
            expoNeg = logc:ceil(-expoNeg)+1; 
            expoNeg = expoNeg(end:-1:1);
            ticksNeg = 10.^expoNeg;
            expo = [-expoNeg nan expo];
            ticks = [-ticksNeg 0 ticks];
        end
        minors = nan(1,8*(length(ticks)));
        lbls = cell(size(ticks));
        for ii = 1:length(ticks)
            if (ticks(ii) < 0)
                if (useExp)
                    lbls{ii} = ['$-10^{',num2str(-expo(ii)),'}$'];
                else
                    lbls{ii} = num2str(ticks(ii));
                end
                minors(8*(ii-1)+(1:8)) = (9:-1:2) * ticks(ii)/10;
            elseif (ticks(ii) > 0)
                 if (useExp)
                    lbls{ii} = ['$10^{',num2str(expo(ii)),'}$'];
                else
                    lbls{ii} = num2str(ticks(ii));
                end
                minors(8*(ii-1)+(1:8)) = (2:9) * ticks(ii)/10;
            else
                lbls{ii} = '0';
                continue;
            end
        end
        minors(isnan(minors)) = [];
        minors = sign(minors).*log10(1+abs(minors)/C);
        ticks = sign(ticks).*log10(1+abs(ticks)/C);
        set(axes,[ch,'Tick'],ticks,[ch,'TickLabel'],lbls,[ch,'MinorTick'],'on', ...
        [ch,'MinorGrid'],'on', 'TickLabelInterpreter', 'latex'); 
        set(get(axes,[ch,'Ruler']),'MinorTickValues',minors)
    end  
end