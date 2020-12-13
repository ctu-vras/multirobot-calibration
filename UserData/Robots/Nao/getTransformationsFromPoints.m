FILENAME = 'headAlt';
BODY_PART = 'rightArm';

% a = importdata(['Robots/Nao/Dataset/Points/', FILENAME, '.txt'],' ', 4);
% a = a.data;

a = load('3D_reconstruction/dense_reconstruction/outputs/parsed_for_calib/rightArm_3Drec');
a = a.rightArm;

if strcmp(BODY_PART, 'leftArm') || strcmp(BODY_PART, 'rightArm')
    arr1=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
    arr2=[19,20,21,22,23,25,26,31];
elseif strcmp(BODY_PART, 'torso')
    arr1=[0,1,2,3,4,5,8,9,10,11,12,13,14,15];
    arr2=[16,17,18,24,25,26,27,28,29,30,31];
elseif strcmp(BODY_PART, 'head')
    arr1=[0,1,2,3,4,5,6,7,8,12,13,15];
    arr2=[16,17,18,19,20,21,22,23,24,28,29,31];
end
    
both = [arr1, arr2];
p1 = a(arr1(1)*12+4,1:3);
p2 = a(arr2(1)*12+4,1:3);
ts=[];



for t=1:size(both, 2)
    if both(t)==arr1(1) || both(t)==arr2(1)
        ts=[ts;zeros(1,3)];
    else
        if ismember(both(t),arr1)
            ts=[ts;a(both(t)*12+4, 1:3)-p1];
        else
            ts=[ts;a(both(t)*12+4, 1:3)-p2];
        end
    end
end

taxels = [];
ts_index = 1;
ts_last = 0;
for t=0:size(a,1)-1
    taxel_num = mod(t,12);
    if taxel_num ~= 6 && taxel_num ~= 10
        triangle_num = fix(t/12);
        if triangle_num~=ts_last
           ts_index = ts_index + 1; 
        end
        if ismember(triangle_num, both)
            if taxel_num == 0
                if ismember(triangle_num, arr1)
                    taxel = a(t+4,1:3)-p1-ts(ts_index);
                    taxels = [taxels; a(t+1,1:3)-p1-ts(ts_index)-taxel];
                else
                    taxel = a(t+4,1:3)-p2-ts(ts_index);
                    taxels = [taxels; a(t+1,1:3)-p2-ts(ts_index)-taxel];
                end
            elseif taxel_num == 3
                taxels = [taxels;zeros(1,3)];
            else
                if ismember(triangle_num, arr1)
                    taxels = [taxels;a(t+1,1:3)-p1-ts(ts_index)-taxel];
                else
                    taxels = [taxels;a(t+1,1:3)-p2-ts(ts_index)-taxel];
                end    
            end
        end
        ts_last = triangle_num;
    end 
end

file=fopen(['Robots/Nao/Dataset/Transformations/',BODY_PART,'_new.txt'],'w');
formatSpec='%5.8f %5.8f %5.8f\n';
fprintf(file,formatSpec, [0,0,0], p1, p2, ts', taxels');
