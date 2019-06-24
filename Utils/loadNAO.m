function loadNAO(robot)
    optProperties=robot.optProperties;
    %% Solver options
    options = optimoptions('lsqnonlin');
    %options.Algorithm = 'trust-region-reflective';
    options.Algorithm = 'levenberg-marquardt';
    options.Display = 'iter';
    options.TolFun = 1e-10;
    options.TolX = 1e-16;
    options.MaxIter = 100;
    options.InitDamping = 1000;
    options.MaxFunctionEvaluations=9999999;

    optProperties.options=options;
    
    %% Patches
    optProperties.patches.hands_upper=[7,8,9,10,11,14,15,0,13,12,1,2,3,4,5,6];
    optProperties.patches.hands_lower=[19,22,23,25,26,20,21,31];
    optProperties.patches.head_left=[0,1,2,3,4,5,6,7,8,12,13,15];
    optProperties.patches.head_right=[16,17,18,19,20,21,22,23,24,28,29,31];
    optProperties.patches.torso_left=[0,1,2,3,4,5,8,9,10,11,12,13,14,15];
    optProperties.patches.torso_right=[16,17,18,24,25,26,27,28,29,30,31];

%     %% Self touch
%     optProperties.offsets.selftouch=0;
%     optProperties.triangles.selftouch=false;
%     optProperties.patches.selftouch=false;
%     optProperties.selftouch=0;
%     %% Optimization type
%     optProperties.offsets.optimize=1;
%     optProperties.triangles.optimize=0; 
%     optProperties.patches.optimize=0;
%     
%     %% Each optimization type settings
%     optProperties.offsets.repetitions=5;
%     optProperties.offsets.optRepetitions=1;
%     optProperties.offsets.batchSize=1;
%     
%     optProperties.triangles.repetitions=1;
%     optProperties.triangles.optRepetitions=1;
%     optProperties.triangles.batchSize=1;
%     
%     optProperties.patches.repetitions=1;
%     optProperties.patches.optRepetitions=1;
%     optProperties.patches.batchSize=1;
%          
%     %% DH/Translation only
%     optProperties.triangles.withTr=false;
%     optProperties.triangles.withDH=true;
%     optProperties.patches.withDH=true;
%     
%     if optProperties.triangles.withTr
%         optProperties.triangles.suffix='Tr';
%     else
%         optProperties.triangles.suffix='';
%     end
% 
%     
%     %% Chains
%         optProperties.part1='right_hand';
%         optProperties.part2='head';
%            
%         if strcmp(optProperties.part1,'right_hand') && strcmp(optProperties.part2,'torso')
%             configuration=1;
%         elseif strcmp(optProperties.part1,'left_hand') && strcmp(optProperties.part2,'torso')
%             configuration=2;
%         elseif strcmp(optProperties.part1,'right_hand') && strcmp(optProperties.part2,'head')
%             configuration=3;
%         elseif strcmp(optProperties.part1,'left_hand') && strcmp(optProperties.part2,'head')
%             configuration=4;
%         end
%         
%     %% Configuration select
%     switch configuration
%         case 1  
%             optProperties.name='right_handtorso';
%             optProperties.filename=strcat(robot.home,'/../Opt/OptimizedParameters/optedDHRightOffsets.txt');
%             optProperties.filename2=strcat(robot.home,'/../Opt/OptimizedParameters/optedDHTorsoOffsets.txt');
%             optProperties.filenameT=strcat(robot.home,'/../Opt/OptimizedParameters/optedDHRightTriangles',optProperties.triangles.suffix,'.txt');
%             optProperties.filenameT2=strcat(robot.home,'/../Opt/OptimizedParameters/optedDHTorsoTriangles',optProperties.triangles.suffix,'.txt');
%             optProperties.filenameP=strcat(robot.home,'/../Opt/OptimizedParameters/optedDHRightPatches.txt');
%             optProperties.filenameP2=strcat(robot.home,'/../Opt/OptimizedParameters/optedDHTorsoPatches.txt');
%             optProperties.patches.patch11.triangles=optProperties.patches.hands_upper;
%             optProperties.patches.patch12.triangles=optProperties.patches.hands_lower;
%             optProperties.patches.patch21.triangles=optProperties.patches.torso_left;
%             optProperties.patches.patch22.triangles=optProperties.patches.torso_right;
%         case 2
%             optProperties.name='left_handtorso';
%             optProperties.filename=strcat(robot.home,'/../Opt/OptimizedParameters/optedDHLeftOffsets.txt');
%             optProperties.filename2=strcat(robot.home,'/../Opt/OptimizedParameters/optedDHTorsoOffsets.txt');
%             optProperties.filenameT=strcat(robot.home,'/../Opt/OptimizedParameters/optedDHLeftTriangles',optProperties.triangles.suffix,'.txt');
%             optProperties.filenameT2=strcat(robot.home,'/../Opt/OptimizedParameters/optedDHTorsoTriangles',optProperties.triangles.suffix,'.txt');
%             optProperties.filenameP=strcat(robot.home,'/../Opt/OptimizedParameters/optedDHLeftPatches.txt');
%             optProperties.filenameP2=strcat(robot.home,'/../Opt/OptimizedParameters/optedDHTorsoPatches.txt');
%             optProperties.patches.patch11.triangles=optProperties.patches.hands_upper;
%             optProperties.patches.patch12.triangles=optProperties.patches.hands_lower;
%             optProperties.patches.patch21.triangles=optProperties.patches.torso_left;
%             optProperties.patches.patch22.triangles=optProperties.patches.torso_right;
%         case 3
%             optProperties.name='right_handhead';
%             optProperties.filename=strcat(robot.home,'/../Opt/OptimizedParameters/optedDHRightOffsets.txt');
%             optProperties.filename2=strcat(robot.home,'/../Opt/OptimizedParameters/optedDHHeadOffsets.txt');
%             optProperties.filenameT=strcat(robot.home,'/../Opt/OptimizedParameters/optedDHRightTriangles',optProperties.triangles.suffix,'.txt');
%             optProperties.filenameT2=strcat(robot.home,'/../Opt/OptimizedParameters/optedDHHeadTriangles',optProperties.triangles.suffix,'.txt');
%             optProperties.filenameP=strcat(robot.home,'/../Opt/OptimizedParameters/optedDHRightPatches.txt');
%             optProperties.filenameP2=strcat(robot.home,'/../Opt/OptimizedParameters/optedDHHeadPatches.txt');
%             optProperties.patches.patch11.triangles=optProperties.patches.hands_upper;
%             optProperties.patches.patch12.triangles=optProperties.patches.hands_lower;
%             optProperties.patches.patch21.triangles=optProperties.patches.head_left;
%             optProperties.patches.patch22.triangles=optProperties.patches.head_right;
%         case 4
%             optProperties.name='left_handhead';
%             optProperties.filename=strcat(robot.home,'/../Opt/OptimizedParameters/optedDHLeftOffsets.txt');
%             optProperties.filename2=strcat(robot.home,'/../Opt/OptimizedParameters/optedDHHeadOffsets.txt');
%             optProperties.filenameT=strcat(robot.home,'/../Opt/OptimizedParameters/optedDHLeftTriangles',optProperties.triangles.suffix,'.txt');
%             optProperties.filenameT2=strcat(robot.home,'/../Opt/OptimizedParameters/optedDHHeadTriangles',optProperties.triangles.suffix,'.txt');
%             optProperties.filenameP=strcat(robot.home,'/../Opt/OptimizedParameters/optedDHLeftPatches.txt');
%             optProperties.filenameP2=strcat(robot.home,'/../Opt/OptimizedParameters/optedDHHeadPatches.txt');
%             optProperties.patches.patch11.triangles=optProperties.patches.hands_upper;
%             optProperties.patches.patch12.triangles=optProperties.patches.hands_lower;
%             optProperties.patches.patch21.triangles=optProperties.patches.head_left;
%             optProperties.patches.patch22.triangles=optProperties.patches.head_right;
%     end
% 
%     optProperties.twoChains=1;
%     optProperties.part3='left_hand';
%     optProperties.name2='left_handhead';
%     optProperties.filenameTwoChains=strcat(robot.home,'/../Opt/OptimizedParameters/optedDHLeftOffsets.txt');
%     %optProperties.filenameTwoChains=strcat(robot.home,'/../Opt/OptimizedParameters/optedDHHeadOffsets.txt');
%     optProperties.filenameTwoChainsT=strcat(robot.home,'/../Opt/OptimizedParameters/optedDHLeftTriangles',optProperties.triangles.suffix,'.txt');
%     optProperties.filenameTwoChainsP=strcat(robot.home,'/../Opt/OptimizedParameters/optedDHLeftPatches.txt');
%     optProperties.patches.patchTwo1.triangles=optProperties.patches.hands_upper;
%     optProperties.patches.patchTwo2.triangles=optProperties.patches.hands_lower;
%     
%     optimizedPart=1;
%     
%     if optProperties.twoChains
%        optimizedPart=2; 
%     end
%     
%     if optProperties.selftouch
%        optimizedPart=1; 
%     end
%     %% Optimized part select
%     switch optimizedPart
%         case 1
%             %Optimize part1
%             delimiterIn = ' ';
%             headerlinesIn = 1;
%             optProperties.DHFilename = importdata(optProperties.filename,delimiterIn,headerlinesIn);
%             optProperties.DH2Filename = importdata(optProperties.filename2,delimiterIn,headerlinesIn);
%             optProperties.triangles1Filename = importdata(optProperties.filenameT,delimiterIn,headerlinesIn);
%             optProperties.triangles2Filename = importdata(optProperties.filenameT2,delimiterIn,headerlinesIn);
%             optProperties.patches1Filename = importdata(optProperties.filenameP,delimiterIn,headerlinesIn);
%             optProperties.patches2Filename = importdata(optProperties.filenameP2,delimiterIn,headerlinesIn);
%             optProperties.optSecond=false;
%         case 2
%             %Optimize part2
%             delimiterIn = ' ';
%             headerlinesIn = 1;
%             optProperties.DHFilename = importdata(optProperties.filename2,delimiterIn,headerlinesIn);
%             optProperties.DH2Filename = importdata(optProperties.filename,delimiterIn,headerlinesIn);
%             optProperties.triangles1Filename = importdata(optProperties.filenameT2,delimiterIn,headerlinesIn);
%             optProperties.triangles2Filename = importdata(optProperties.filenameT,delimiterIn,headerlinesIn);
%             optProperties.optSecond=true;
%             optProperties.filenameBack=optProperties.filename;
%             optProperties.filename=optProperties.filename2;
%             optProperties.patches1Filename = importdata(optProperties.filenameP2,delimiterIn,headerlinesIn);
%             optProperties.patches2Filename = importdata(optProperties.filenameP,delimiterIn,headerlinesIn);
%     end
% 
%     %% Select which parameters to use
%     optProperties.loadOptimizedOffsets =  -1; %Which saved parameters of offsets to use for optimized part, if 0 => [0,0,0,0], -1 => last
%     optProperties.loadOptimizedOffsets2 = -1; %Which saved parameters of offsets to use for second part, if 0 => [0,0,0,0], -1 => last
%     optProperties.loadOptimizedOffsets3 = -1; %Which saved parameters of offsets to use for second part, if 0 => [0,0,0,0], -1 => last
%     optProperties.loadOptimizedTriangles = -1; %Which saved parameters of offsets to use for optimized part, if 0 => [0,0,0,0], -1 => last
%     optProperties.loadOptimizedTriangles2 = -1;%Which saved parameters of offsets to use for second part, if 0 => zeros, -1 => last
%     optProperties.loadOptimizedTriangles3 = -1;
%     optProperties.loadOptimizedPatches = -1;
%     optProperties.loadOptimizedPatches2 = -1;
%     optProperties.loadOptimizedPatches3 = -1;
%     %% Parameters settings
%     optProperties.writeMode = 'a'; % 'a' for new parameters, 'w' for changing the current ones
%     optProperties.offsets.DH=[true,true,true,true]; % a,d,alpha,theta parameters, optmized when true
% 
%     for i=1:32
%         optProperties.triangles.(strcat('t',num2str(i))).DH=[true,true,true,true]; %Set all triangles to optimize given DH
%     end
% 
%     for i=1:32
%         optProperties.triangles.(strcat('t',num2str(i))).tr=[true,true,true]; %Set all triangles to optimize given DH
%     end
% 
%     for i=1:2
%         optProperties.patches.(strcat('patch',num2str(i))).DH=[true,true,true,true]; %Set all triangles to optimize given DH
%     end
% 
%     optProperties.triangles.allOn=true; %Set to optimize all triangles
% 
%     if optProperties.triangles.allOn
%         for i=1:32
%             optProperties.triangles.(strcat('t',num2str(i))).optimize=true; 
% 
%         end
%     end
%     optProperties.triangles.allOff=false; %Set not to optimize all triangles
% 
%     if optProperties.triangles.allOff
%         for i=1:32
%                 optProperties.triangles.(strcat('t',num2str(i))).optimize=false; 
%         end
%     end
% 
%     %optProperties.triangles.t27.optimize=true; % Turn on one given triangle
% 
% 
%     %% Bounds for algs
%     optProperties.offsets.bounds=0;
%     optProperties.offsets.lowerBounds=[-15,-15,-pi,-pi];
%     optProperties.offsets.upperBounds=[15,15,pi,pi];
% 
%     optProperties.triangles.bounds=false;
%     optProperties.triangles.lowerBounds=[-1,-1,-pi/20,-pi/20];
%     optProperties.triangles.upperBounds=[1,1,pi/20,pi/20];
% 
%     optProperties.patches.bounds=false;
%     optProperties.patches.lowerBounds=[-1,-inf,-pi/20,-pi/20];
%     optProperties.patches.upperBounds=[1,inf,pi/20,pi/20];
%     
%     %% Perturbations
%     optProperties.offsets.perturbations=[0,0,0,0]; %a,d,alpha,theta
%     optProperties.patches.perturbations=[0,0,0,0];
%     optProperties.triangles.perturbations=[0,0,0,0];%a,d,alpha,theta/x,y,z,~

    
    %% Robot structure
    optProperties.structure={{'torso','base',nan,[0 0 0 0],[0,0,0,0],[0,0,0,0],0,[0,0,0,0],[0,0,0,0]},...
        {'headYaw','joint',1,[0, 0.1265, 0, 0],[0,0,0,0],[0,0,0,0],0,[0,0,0,0],[0,0,0,0]},...
        {'headPitch','joint',2,[0,0,-pi/2,0],[0,0,0,0],[0,0,0,0],0,[0,0,0,0],[0,0,0,0]},...
        {'headPlastic','mount',3,[0,0,0,0],[1,1,1,1],[0,0,0,0],1,[0,0,0,0],[0,0,0,0]},...
        {'headLeftPatch','patch',4,[0,0,0,0],[1,1,1,1],[0,0,0,0],1,[0,0,0,0],[0,0,0,0]},...
        {'headRightPatch','patch',4,[0,0,0,0],[1,1,1,1],[0,0,0,0],1,[0,0,0,0],[0,0,0,0]},...
        {'leftShoulderPitch','joint',1,[0,  0.1, -pi/2,  0],[0,0,0,0],[0,0,0,0],0,[0,0,0,0],[0,0,0,0]},...
        {'leftShoulderRoll','joint',7,[0, 0.098, pi/2, 0],[0,0,0,0],[0,0,0,0],0,[0,0,0,0],[0,0,0,0]},...
        {'leftElbowYaw','joint',8,[0, 0, pi/2, pi/2],[0,0,0,0],[0,0,0,0],0,[0,0,0,0],[0,0,0,0]},...
        {'leftElbowRoll','joint',9,[0, 0.105, -pi/2, 0.0],[0,0,0,0],[0,0,0,0],0,[0,0,0,0],[0,0,0,0]},...
        {'leftWristYaw','joint',10,[ 0, 0.0, pi/2, 0],[0,0,0,0],[0,0,0,0],0,[0,0,0,0],[0,0,0,0]},...
        {'leftPlastic','mount',11,[ 0, 0, -pi/2, pi],[1,1,1,1],[0,0,0,0],1,[0,0,0,0],[0,0,0,0]},...
        {'leftUpperPatch','patch',12,[ 0, 0, 0, 0],[1,1,1,1],[0,0,0,0],1,[0,0,0,0],[0,0,0,0]},...
        {'leftLowerPatch','patch',12,[ 0, 0, 0, 0],[1,1,1,1],[0,0,0,0],1,[0,0,0,0],[0,0,0,0]},...
        {'rightShoulderPitch','joint',1,[0, 0.1, -pi/2, 0],[0,0,0,0],[0,0,0,0],0,[0,0,0,0],[0,0,0,0]},...
        {'rightShoulderRoll','joint',15,[0, -0.098, pi/2, 0],[0,0,0,0],[0,0,0,0],0,[0,0,0,0],[0,0,0,0]},...
        {'rightElbowYaw','joint',16,[0, 0,  pi/2, pi/2],[0,0,0,0],[0,0,0,0],0,[0,0,0,0],[0,0,0,0]},...
        {'rightElbowRoll','joint',17,[0, 0.105, -pi/2, 0.0],[0,0,0,0],[0,0,0,0],0,[0,0,0,0],[0,0,0,0]},...
        {'rightWristYaw','joint',18,[ 0, 0, pi/2, 0],[0,0,0,0],[0,0,0,0],0,[0,0,0,0],[0,0,0,0]},...
        {'rightPlastic','mount',19,[ 0, 0, -pi/2, pi],[1,1,1,1],[0,0,0,0],1,[0,0,0,0],[0,0,0,0]},...
        {'rightUpperPatch','patch',20,[ 0, 0, 0, 0],[1,1,1,1],[0,0,0,0],1,[0,0,0,0],[0,0,0,0]},...
        {'rightLowerPatch','patch',20,[ 0, 0, 0, 0],[1,1,1,1],[0,0,0,0],1,[0,0,0,0],[0,0,0,0]},...
        {'torsoPlastic','mount',1,[0,0,0,0],[1,1,1,1],[0,0,0,0],1,[0,0,0,0],[0,0,0,0]},...
        {'torsoLeftPatch','patch',23,[ 0, 0, 0, 0],[1,1,1,1],[0,0,0,0],1,[0,0,0,0],[0,0,0,0]},...
        {'torsoRightPatch','patch',23,[ 0, 0, 0, 0],[1,1,1,1],[0,0,0,0],1,[0,0,0,0],[0,0,0,0]}};
    for triangleId=optProperties.patches.hands_upper
        optProperties.structure{end+1}={strcat('rightTriangle',num2str(triangleId)),'triangle',21,[0,0,0,0],[1,1,1,1],[0,0,0,0],1,[0,0,0,0],[0,0,0,0]};
        optProperties.structure{end+1}={strcat('leftTriangle',num2str(triangleId)),'triangle',13,[0,0,0,0],[1,1,1,1],[0,0,0,0],1,[0,0,0,0],[0,0,0,0]};
    end
    for triangleId=optProperties.patches.hands_lower
        optProperties.structure{end+1}={strcat('rightTriangle',num2str(triangleId)),'triangle',22,[0,0,0,0],[1,1,1,1],[0,0,0,0],1,[0,0,0,0],[0,0,0,0]};
        optProperties.structure{end+1}={strcat('leftTriangle',num2str(triangleId)),'triangle',14,[0,0,0,0],[1,1,1,1],[0,0,0,0],1,[0,0,0,0],[0,0,0,0]};
    end
    for triangleId=optProperties.patches.head_left
        optProperties.structure{end+1}={strcat('headTriangle',num2str(triangleId)),'triangle',5,[0,0,0,0],[1,1,1,1],[0,0,0,0],1,[0,0,0,0],[0,0,0,0]};
    end
    for triangleId=optProperties.patches.head_right
        optProperties.structure{end+1}={strcat('headTriangle',num2str(triangleId)),'triangle',6,[0,0,0,0],[1,1,1,1],[0,0,0,0],1,[0,0,0,0],[0,0,0,0]};
    end
    for triangleId=optProperties.patches.torso_left
        optProperties.structure{end+1}={strcat('torsoTriangle',num2str(triangleId)),'triangle',24,[0,0,0,0],[1,1,1,1],[0,0,0,0],1,[0,0,0,0],[0,0,0,0]};
    end
    for triangleId=optProperties.patches.torso_right
        optProperties.structure{end+1}={strcat('torsoTriangle',num2str(triangleId)),'triangle',25,[0,0,0,0],[1,1,1,1],[0,0,0,0],1,[0,0,0,0],[0,0,0,0]};
    end
    %optProperties=reloadParametersNAO(optProperties);
    robot.structure={{'left_arm',[0, 0.1, -pi/2, 0;
               0, 0.098, pi/2, 0;
               0, 0,  pi/2, pi/2;
               0, 0.105, -pi/2, 0.0;
               0, 0.0, pi/2, 0;
               0, 0, -pi/2, pi]},...
        {'right_arm',[0, 0.1, -pi/2, 0; 
               0, -0.098, pi/2, 0;
               0, 0,  pi/2, pi/2;
               0, 0.105, -pi/2, 0.0;
               0, 0, pi/2, 0;
               0, 0, -pi/2, pi]},...
        {'head',[0, 0.1265, 0, 0.0;
         0, 0, -pi/2, 0;
         0,0,0,0]}};
    robot.optProperties=optProperties;
end