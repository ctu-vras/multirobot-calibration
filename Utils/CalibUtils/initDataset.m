function dataset  = initDataset(all)
%INITDATASET Create empty dataset structure 
%INPUT - all - if true create fields not needed for calibration
%OUTPUT - dataset - empty dataset structure
    dataset.frame = {};
    dataset.frame2 = {};
    dataset.cameras = [];
    dataset.pose = [];
    dataset.joints = struct();
    dataset.refPoints = [];
    dataset.point = [];
    if (all) 
        dataset.refDist = 0; 
        dataset.rtMat = [];  
        dataset.name = '';
        dataset.id = -1;

    end
end

