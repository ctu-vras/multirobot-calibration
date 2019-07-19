function loadDHfromTxt(robot, folder, file)
%LOADDHFROMTXT Summary of this function goes here
%   Detailed explanation goes here
fileID = fopen(['results/',folder,'/',file,'.txt']);
C = textscan(fileID,'%s %s %s %s %s');
A = [str2double(C{2}),str2double(C{3}),str2double(C{4}),str2double(C{5})];
groups = {C{1}{isnan(A(:,1))}};
idx = [find(isnan(A(:,1))); size(A,1)+1];
for i = 1:length(groups)
    robot.structure.DH.(groups{i})= A(idx(i)+1:idx(i+1)-1,:);
end
fclose(fileID);
end

