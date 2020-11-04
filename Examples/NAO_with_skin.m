folder = 'NAO_visu';
load(strcat('Results/',folder, '/info'));
load(strcat('Results/',folder, '/results.mat'));
loadDHfromMat(rob, folder);
rob.showModel();