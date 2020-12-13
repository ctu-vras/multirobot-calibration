function str = unpadVectors(str, DH, type)
% PADVECTORS unpad vector and get it back to default form set by user
%   INPUT - str - structure to unpad
%         - DH - Robot DH structure
%         - type - structure: 0 - only DH; 1 - only RT; 2 - mixed trans
%   OUTPUT - str - structure with the same fields as input with unpadded
%                  values
    for name=fieldnames(str)'
        name = name{1};
        str.(name) = double(str.(name));
        if isfield(type, name) && type.(name) == 0 %if only DH
           str.(name) = str.(name)(:, [1,2,4,6],:, :); %reorder back to default vector of size 4  
        elseif isfield(type, name) && type.(name) == 2 % if mixed notation
           for line=size(type.(name),1)
              if any(isnan(DH.(name)(line, :))) %if DH line
%                   if ~isa(str.(name)(line, :), 'logical') %if vector is not whitelist
                    %all maximal 4 dimension reordered and added nans to
                    %have vector of size 6
                    str.(name)(line, :, :, :) = [str.(name)(line, [1,2,4,6], :, :),nan(1,2,size(str.(name)(line, :, :, :),3),size(str.(name)(line, :, :, :),4))];
%                   else
%                     str.(name)(line, :, :, :) = [str.(name)(line, [1,2,4,6], :, :),zeros(1,2,size(str.(name)(line, :, :, :),3),size(str.(name)(line, :, :, :),4))];  
%                   end
              end
           end
        end
    end
end