function loadDHfromTxt(robot, folder, file)
%LOADDHFROMTXT Loading robot DH from a text file
%   Function for loading robot DH from a text file saved in a subfolder in
%   folder Results
%INPUT - robot - Robot object to store DH 
%      - folder - folder with the required txt file
%      - file - file with the required DH
fileID = fopen(['Results/',folder,'/',file,'.txt']);
% load the columns with values
C = textscan(fileID,'%s %s %s %s %s');
% convert values to double
A = [str2double(C{2}),str2double(C{3}),str2double(C{4}),str2double(C{5})];
groups = {C{1}{isnan(A(:,1))}};
idx = [find(isnan(A(:,1))); size(A,1)+1];
% save DH for each group
for i = 1:length(groups)
    robot.structure.DH.(groups{i})= A(idx(i)+1:idx(i+1)-1,:);
end
fclose(fileID);
end

