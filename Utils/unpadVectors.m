function str = unpadVectors(str, rob)
% PADVECTORS unpad vector and get it back to default form set by user
%   INPUT - str - structure to unpad
%         - rob - Robot class object
%   OUTPUT - str - structure with the same fields as input with unpadded
%                  values
    for name=fieldnames(str)'
        name = name{1};
        if isfield(rob.structure.type, name) && rob.structure.type.(name) == 0 %if only DH
           str.(name) = str.(name)(:, [1,2,4,6],:, :); %reorder back to default vector of size 4  
        elseif isfield(rob.structure.type, name) && rob.structure.type.(name) == 2 % if mixed notation
           for line=size(rob.structure.type.(name),1)
              if any(isnan(rob.structure.DH.(name)(line, :))) %if DH line
                  if ~isa(str.(name)(line, :), 'logical') %if vector is not whitelist
                    %all maximal 4 dimension reordered and added nans to
                    %have vector of size 6
                    str.(name)(line, :, :, :) = [str.(name)(line, [1,2,4,6], :, :),nan(1,2,size(str.(name)(line, :, :, :),3),size(str.(name)(line, :, :, :),4))];
                  else
                    str.(name)(line, :, :, :) = [str.(name)(line, [1,2,4,6], :, :),zeros(1,2,size(str.(name)(line, :, :, :),3),size(str.(name)(line, :, :, :),4))];  
                  end
              end
           end
        end
    end
end