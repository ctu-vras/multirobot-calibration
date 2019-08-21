function [name, jointStructure, structure]=loadNAO()
    %LOADNAO returns structure of the NAO robot
    %   OUTPUT - name - string name of the robot
    %          - jointStructure - joint structure of the robot
    %          - structure - DH,WL and bounds of the robot
    
    %% Patches
    hands_upper=[7,8,9,10,11,14,15,0,13,12,1,2,3,4,5,6];
    hands_lower=[19,22,23,25,26,20,21,31];
    head_left=[0,1,2,3,4,5,6,7,8,12,13,15];
    head_right=[16,17,18,19,20,21,22,23,24,28,29,31];
    torso_left=[0,1,2,3,4,5,8,9,10,11,12,13,14,15];
    torso_right=[16,17,18,24,25,26,27,28,29,30,31];
    
    %% Robot structure
    jointStructure={{'base',types.base,nan,0,group.torso},...
        ...
        {'headYaw',types.joint,'base',1,group.head},...
        {'headPitch',types.joint,'headYaw',2,group.head},...
        {'headEE',types.joint,'headPitch',3,group.head},...
        ...
        {'headPlastic',types.mount,'headEE',1,group.headSkin},...
        {'headLeftPatch',types.patch,'headPlastic',2,group.headSkin},...
        {'headRightPatch',types.patch,'headPlastic',3,group.headSkin},...
        ...
        {'leftShoulderPitch',types.joint,'base',1,group.leftArm},...
        {'leftShoulderRoll',types.joint,'leftShoulderPitch',2,group.leftArm},...
        {'leftElbowYaw',types.joint,'leftShoulderRoll',3,group.leftArm},...
        {'leftElbowRoll',types.joint,'leftElbowYaw',4,group.leftArm},...
        {'leftWristYaw',types.joint,'leftElbowRoll',5,group.leftArm},...
        {'leftEE',types.joint,'leftWristYaw',6,group.leftArm},...
        ...
        {'leftPlastic',types.mount,'leftEE',1,group.leftArmSkin},...
        {'leftUpperPatch',types.patch,'leftPlastic',2,group.leftArmSkin},...
        {'leftLowerPatch',types.patch,'leftPlastic',3,group.leftArmSkin},...
        ...
        {'rightShoulderPitch',types.joint,'base',1,group.rightArm},...
        {'rightShoulderRoll',types.joint,'rightShoulderPitch',2,group.rightArm},...
        {'rightElbowYaw',types.joint,'rightShoulderRoll',3,group.rightArm},...
        {'rightElbowRoll',types.joint,'rightElbowYaw',4,group.rightArm},...
        {'rightWristYaw',types.joint,'rightElbowRoll',5,group.rightArm},...
        {'rightEE',types.joint,'rightWristYaw',6,group.rightArm},...
        ...
        {'rightPlastic',types.mount,'rightEE',1,group.rightArmSkin},...
        {'rightUpperPatch',types.patch,'rightPlastic',2,group.rightArmSkin},...
        {'rightLowerPatch',types.patch,'rightPlastic',3,group.rightArmSkin},...
        ...
        {'torsoPlastic',types.mount,'base',1,group.torsoSkin},...
        {'torsoLeftPatch',types.patch,'torsoPlastic',2,group.torsoSkin},...
        {'torsoRightPatch',types.patch,'torsoPlastic',3,group.torsoSkin}};
    %% Assign triangles into the structure
    for triangleId=1:size(hands_upper,2)
        jointStructure{end+1}={strcat('rightTriangle',num2str(hands_upper(triangleId))),types.triangle,'rightUpperPatch',triangleId+3,group.rightArmSkin};
        jointStructure{end+1}={strcat('leftTriangle',num2str(hands_upper(triangleId))),types.triangle,'leftUpperPatch',triangleId+3,group.leftArmSkin};
    end
    for triangleId=1:size(hands_lower,2)
        jointStructure{end+1}={strcat('rightTriangle',num2str(hands_lower(triangleId))),types.triangle,'rightLowerPatch',triangleId+3+size(hands_upper,2),group.rightArmSkin};
        jointStructure{end+1}={strcat('leftTriangle',num2str(hands_lower(triangleId))),types.triangle,'leftLowerPatch',triangleId+3+size(hands_upper,2),group.leftArmSkin};
    end
    for triangleId=1:size(head_left,2)
        jointStructure{end+1}={strcat('headTriangle',num2str(head_left(triangleId))),types.triangle,'headLeftPatch',triangleId+3,group.headSkin};
    end
    for triangleId=1:size(head_right,2)
        jointStructure{end+1}={strcat('headTriangle',num2str(head_right(triangleId))),types.triangle,'headRightPatch',triangleId+3+size(head_left,2),group.headSkin};
    end
    for triangleId=1:size(torso_left,2)
        jointStructure{end+1}={strcat('torsoTriangle',num2str(torso_left(triangleId))),types.triangle,'torsoLeftPatch',triangleId+3,group.torsoSkin};
    end
    for triangleId=1:size(torso_right,2)
        jointStructure{end+1}={strcat('torsoTriangle',num2str(torso_right(triangleId))),types.triangle,'torsoRightPatch',triangleId+3+size(torso_left,2),group.torsoSkin};
    end
    %% DH
    structure.DH.leftArm=[0, 0.1, -pi/2, 0;
               0, 0.098, pi/2, 0;
               0, 0,  pi/2, pi/2;
               0, 0.105, -pi/2, 0.0;
               0, 0.0, pi/2, 0;
               0, 0, -pi/2, pi];
    structure.DH.rightArm=[0, 0.1, -pi/2, 0; 
               0, -0.098, pi/2, 0;
               0, 0,  pi/2, pi/2;
               0, 0.105, -pi/2, 0.0;
               0, 0, pi/2, 0;
               0, 0, -pi/2, pi];
    structure.DH.head=[0, 0.1265, 0, 0.0;
         0, 0, -pi/2, 0;
         0,0,0,0];
    structure.DH.torsoSkin=zeros(3+size(torso_left,2)+size(torso_right,2),4);
    structure.DH.leftArmSkin=[0,0,0,0;zeros(size(hands_upper,2)+size(hands_lower,2)+2,4)];
    structure.DH.rightArmSkin=zeros(size(hands_upper,2)+size(hands_lower,2)+3,4);

    rightArmSkinTranslation=[ 0,0,0;
                              0.101694123721709  -0.019226197624457   0.036588580347741;
                              0.017100725219080  -0.015006077434594  -0.033079984551738;
                                               0                   0                   0
                              -0.015483186609809   0.012709111684154   0.003490261341311
                               0.000000000000100   0.032461740197293   0.002606243101102
                              -0.008868615602958   0.051213225552555  -0.011381824905083
                              -0.033812423218923   0.053069443291838  -0.015683791080887
                              -0.036541016977058   0.057361008432619  -0.029424212418159
                              -0.061433205133524   0.057064824513649  -0.034707782212112
                              -0.078051565099660   0.050194925935247  -0.016905398336317
                              -0.040462444733518   0.015967640833422   0.002367027449883
                              -0.044222324554809   0.029476682035301   0.001152840861330
                              -0.069187744782618   0.032418672456097  -0.001662706704933
                              -0.079117177246860   0.022484712952792   0.000119744993274
                              -0.069187744782518   0.000161908495607  -0.004526663392570
                              -0.044222324554909  -0.002855371921605  -0.004392046921199
                              -0.039470207176818  -0.012472572531898  -0.013219819384605
                              -0.014526375563809  -0.014976492536424  -0.013782042425625
                                               0                   0                   0
                               0.023580744243240  -0.008393169779052   0.003740824123195
                               0.027901416442420  -0.017119225914106   0.014331200305538
                               0.033458660595200  -0.000021592678454  -0.002511515243157
                               0.030192132885940   0.024568792622611  -0.003975993466738
                              -0.003266527709360   0.024571858282626  -0.001553577114375
                               0.017047785807400   0.028620115063574  -0.001941647474464
                               0.014835416442340   0.047131372739215   0.014331186477051];
    structure.matrices.rightArmSkin=repmat(eye(4),1,1,3+size(hands_upper,2)+size(hands_lower,2),1);
    for i=1:length(rightArmSkinTranslation)
       structure.matrices.rightArmSkin(:,:,i)=[1,0,0,rightArmSkinTranslation(i,1);
                                      0,1,0,rightArmSkinTranslation(i,2);
                                      0,0,1,rightArmSkinTranslation(i,3);
                                      0,0,0,1];
    end
    leftArmSkinTranslation=[ 0,0,0   
        0.051812470163279   0.019125303370626   0.033582049971352
        0.057092871965085   0.015029826082482  -0.035590922046252
                       0                   0                   0
      -0.013647692261127   0.002876848743409  -0.002953065312372
      -0.029237076724896  -0.015865074590160   0.002670440376182
      -0.019308355260279  -0.038190029441733  -0.001520346133150
      -0.022512830582824  -0.052081157703583  -0.016494236097228
      -0.017211599569079  -0.056243480551265  -0.028515705066909
       0.007682165611293  -0.058129825419845  -0.029568587932306
       0.021728487339684  -0.050825182980771  -0.010214563754753
       0.020736249782984  -0.022385545975928   0.005829396685835
       0.011319337003826  -0.032333118872331   0.002773355597810
       0.041015285994826  -0.046680733472932  -0.003574563358090
       0.049883206582377  -0.038353076043600   0.003005845149327
       0.040058474948826  -0.015866275444911   0.006724617327827
       0.044224644607140   0.003098217194525   0.001702540717735
       0.041015253993802   0.012862110702567  -0.008375712838209
       0.016069845344573   0.014719389102551  -0.012678923063657
                       0                   0                   0
      -0.022946092433505   0.008370764132368   0.006252541526013
      -0.025158934087283   0.017095119753586   0.016841523211702
      -0.033458660595200  -0.000021602406370   0.002511550393398
      -0.030190470666640  -0.024594984799544   0.000957182719157
       0.003268189928660  -0.024591916319699  -0.001465223444207
      -0.016410874787800  -0.028641933532016   0.000568169125318
      -0.012088526514940  -0.047154796059327   0.016841564711156];
       structure.matrices.leftArmSkin=repmat(eye(4),1,1,3+size(hands_upper,2)+size(hands_lower,2),1);
        for i=1:length(leftArmSkinTranslation)
           structure.matrices.leftArmSkin(:,:,i)=[1,0,0,leftArmSkinTranslation(i,1);
                                          0,1,0,leftArmSkinTranslation(i,2);
                                          0,0,1,leftArmSkinTranslation(i,3);
                                          0,0,0,1];
        end
    torsoSkinTranslation=[0,0,0
        0.060674874769321   0.013438639334703  -0.006826543575061
        0.048618333103638  -0.050889819772448  -0.006826543575061
                       0                   0                   0
      -0.003044074116674   0.022810804511679   0.009620023996942
      -0.008340665983851   0.032083751093825                   0
      -0.022521323801376   0.048927202846074   0.009620023996942
      -0.021364890290380   0.052248726539001   0.034647759960861
       0.003825125230679  -0.010172125480043   0.079045495924770
      -0.008078705244835   0.041339702544074   0.063697759960861
      -0.000019953026083   0.022759036076485   0.079045495924770
       0.003451998190558  -0.000011327681987   0.069355519921712
       0.003685889779719  -0.003264112400327   0.044337807954847
      -0.001540930731008   0.026105508004986   0.034647759960861
      -0.006666853408408   0.038445049341838   0.038680023996952
       0.003542390825980  -0.016697834046014   0.040305519921712
       0.002227769342220  -0.019924676074404   0.015277807954837
                       0                   0                   0
       0.010893265534701   0.020901116239945   0.009620023996942
       0.010951400745796   0.031016438456553                   0
       0.015786037276943   0.040721237248230   0.063697759960861
       0.013509026877784   0.021061271364359   0.079045495924770
       0.005506137005058  -0.000996475443007   0.069355519921712
       0.003854175350091  -0.003871835174255   0.044337807954847
       0.013731846979303   0.024013868754566   0.034647759960861
       0.015454156693701   0.037465562993545   0.038680023996952
      -0.006758095379615  -0.012746288154594   0.040305519921712
      -0.013154204020923  -0.013317670360830   0.015277807954837];
   structure.matrices.torsoSkin=repmat(eye(4),1,1,3+size(torso_left,2)+size(torso_right,2),1);
   for i=1:length(torsoSkinTranslation)
       structure.matrices.torsoSkin(:,:,i)=[1,0,0,torsoSkinTranslation(i,1);
                                          0,1,0,torsoSkinTranslation(i,2);
                                          0,0,1,torsoSkinTranslation(i,3);
                                          0,0,0,1];
   end
    headSkinTranslation=[0,0,0
        0.051974719558491   0.014879616271662   0.012578474591425
        0.051974719558491   0.014879616271662   0.012578474591425
                       0                   0                   0
       0.002079303851059   0.014220345538070   0.018145733230549
      -0.007257254870904   0.025524615386072   0.013653103033423
      -0.010312828793240   0.039181840714061   0.031626596035679
      -0.007282029691649   0.031212853744735   0.052880608107410
      -0.015588536160396   0.039545093370445   0.060144879274154
      -0.025514010608391   0.030406330225681   0.077423428208353
      -0.017538972480662   0.009006374761623   0.085613827452526
      -0.001778958121399   0.005496929183785   0.072470524603017
       0.007973512671594   0.005441335022516   0.040215958995585
       0.005897430452000   0.014378231284392   0.049875638559493
      -0.026551430077406   0.005352376582885   0.092407148713429
                       0                   0                   0
       0.013136765725784  -0.014313600226453  -0.014173985813942
       0.002423067740048  -0.025514982960456  -0.014558214815270
       0.010200606856619  -0.039583895538902  -0.029542407697165
       0.026002874876193  -0.031203587201154  -0.047633758737731
       0.021823979438518  -0.039122624767298  -0.058034426697492
       0.021495372001237  -0.030244206409794  -0.078106627320339
       0.031657094772649  -0.008992891614570  -0.080578988398697
       0.038481661009057  -0.005388449437890  -0.059384970154477
       0.031197685508328  -0.005547681721450  -0.027886493474222
       0.029976085561702  -0.014381275125887  -0.038853016403368
       0.031092194337396  -0.005322077395286  -0.092111082454822];
   structure.matrices.headSkin=repmat(eye(4),1,1,3+size(head_left,2)+size(head_right,2),1);
   for i=1:length(headSkinTranslation)
       structure.matrices.headSkin(:,:,i)=[1,0,0,headSkinTranslation(i,1);
                                          0,1,0,headSkinTranslation(i,2);
                                          0,0,1,headSkinTranslation(i,3);
                                          0,0,0,1];
   end
        
    structure.DH.headSkin=zeros(size(head_left,2)+size(head_right,2)+3,4);
    structure.H0 = [1 0 0 0;
                     0 1 0 0;
                     0 0 1 0;
                     0 0 0 1];
    structure.defaultDH = structure.DH;
    
    %% Bounds
    structure.bounds.joint=[inf, inf, inf, inf];
    structure.bounds.mount=[0.15,0.15,pi,pi];
    structure.bounds.patch=[0.007,0.007,pi/20,pi/20];
    structure.bounds.triangle=[0.001,0.001,pi/20,pi/20];
    
    %% Whitelist
    structure.WL.leftArm= ...
              [0, 0, 0, 0;
               0, 0, 0, 0;
               0, 0,  0, 0;
               0, 0, 0, 0.0;
               0, 0, 0, 0;
               0, 0, 0, 0];
    structure.WL.rightArm= ...
              [0, 0, 0, 0; 
               0, 0, 0, 0;
               0, 0, 0, 0;
               0, 0, 0, 0;
               0, 0, 0, 0;
               0, 0, 0, 0];
    structure.WL.head= ...
        [0, 0, 0, 0;
         0, 0, 0, 0;
         0,0,0,0];
    structure.WL.torsoSkin=ones(3+size(torso_left,2)+size(torso_right,2),4);
    structure.WL.leftArmSkin=ones(size(hands_upper,2)+size(hands_lower,2)+3,4);
    structure.WL.rightArmSkin=ones(size(hands_upper,2)+size(hands_lower,2)+3,4);
    structure.WL.headSkin=ones(size(head_left,2)+size(head_right,2)+3,4);
%     structure.torsoSkin=repmat(eye(4),1,1,3+size(torso_left,2)+size(torso_right,2),1);
    %% Name
    name='nao';
end