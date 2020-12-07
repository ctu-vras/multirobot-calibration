function [ name, jointStructure, structure ] = loadKuka()

%LOADEXAMPLEROBOT Template function for loading example robot 
% OUTPUT - name - robot name
%        - joints - cellarray of robot joints (name, type, parent, DHindex, isEE, group)
%        - structure - DH - table of DH parameters for each group (columns - a, d, alpha, offset)
%                    - WL - logical array of whitelisted parameters for calibration 
%                    - defaultJoints - stores robot default joint position
%                    (e.g. home position) for visualisation 
%                    - bounds - bounds for DH parameters (a, d, alpha, offset)
%                    - eyes - cameras and their instrinsic parameters
%                    (camera matrix, distortion coefficents - radial and tangential)
    name='Kuka';
    %% Robot structure
    jointStructure={{'base',types.base,nan,0,group.torso},...
        {'L1',types.joint,'base',1,group.leftArm},...
        {'L2',types.joint,'L1',2,group.leftArm},...
        {'L3',types.joint,'L2',3,group.leftArm},...
        {'L4',types.joint,'L3',4,group.leftArm},...
        {'L5',types.joint,'L4',5,group.leftArm},...
        {'L6',types.joint,'L5',6,group.leftArm},...
        {'L7',types.joint,'L6',7,group.leftArm}};
        
    %% robot initial DH   fields of structure.DH are the ones                  
    structure.DH.leftArm = [ 0, 0.34, -pi/2, 0;
                             0, 0,     pi/2.0, 0;
                             0, 0.4,   pi/2.0, 0;
                             0, 0,    -pi/2.0, 0;
                             0, 0.4,  -pi/2, 0;
                             0, 0,     pi/2, 0;
                             0, -0.126,    0, 0;];
                                           
                               
    %% robot initial whitelist                              
    structure.WL.leftArm = ones(4,4);
       
    %% robot default joint position (e.g. home position) for visualisation    
    structure.defaultJoints = {zeros(1,7)};
    
    %% robot bounds for DH parameters
    structure.bounds.joint = [inf inf inf inf]; % no bounds

end