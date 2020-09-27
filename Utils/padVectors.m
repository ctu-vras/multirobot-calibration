function [str, type] = padVectors(str,wl)
% PADVECTORS pads all vectors to size 6, add nan to free spaces and reorder
%            the vector
%   INPUT - str - structure to pad
%         - wl - 1/0, if 1 the structure is whitelist and nans are replaced
%         with 0 to work as logical vector
%   OUTPUT - str - structure with the same fields as input with padded
%                  vectors
%          - type - structure with the same fields as input with possible
%          values: 0 - field contains only DH representation
%                  1 - field contains only RT matrix representation 
%                  2 - field contains mixed representation

    if ~isa(str, 'struct') % if input is not struct, return 
        type=[];
        return
    end
    if nargin==1 % if no second argument - str is not whitelist
        wl=0;
    end
    for name=fieldnames(str)'
       name = name{1}; 
       str.(name)(:,end+1:6,:, :) = nan; % pad nans to make vector of size 6
       nans = isnan(str.(name));
       if all(any(nans,2)) %Only DH
           type.(name) = 0;
           if all(isnan(str.(name)(:,6))) 
               str.(name)(:,[3,4,6],:, :) = str.(name)(:,[6,3,4],:, :); % a,d,nan,alpha,offset,nan
           end
       elseif all(~any(nans,2)) %Only RT mats
           type.(name) = 1; %x,y,z,alpha,beta,gama
       else %Both
           type.(name) = 2;
           for line=1:size(str.(name),1) %Need to check every line
               if any(isnan(str.(name)(line,:))) %if DH
                   if isnan(str.(name)(line, 6))
                       str.(name)(line,[3,4,6],:, :) = str.(name)(line,[6,3,4],:, :);
                   end
               %else keep vector as it is
               end
           end
       end
       if wl %if str is whitelist, replace nans with 0
          str.(name)(isnan(str.(name))) = 0; 
       end
    end    

end