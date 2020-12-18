function [RTarm] = getTFIntern(dh_pars,link,rtMat, joints, indexes, parents, rtFields, type)
%GETTFIntern computes transformation from given link to base 
%INPUT - dh_pars - kinematics parameters 
%       - link - given link object to start the transformation
%       - rtMat - precomputed matrices
%       - joints - joint angles
%       - indexes - row indexes into kinematics table 
%       - parents - structure of link ancestors for each group)
%       - rtFields - fields in rtMat
%OUTPUT - RTarm - transformation from the link to base
    RTarm= [1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1]; 
    while isobject(link)
        gr = link.group;
        switch gr
            case rtFields
               RT=rtMat.(gr);
            otherwise       
                if ~type.(gr) %types.gr == 0 => only DH links

                    DH=dh_pars.(gr)(indexes.(gr),:)';
                    j = joints.(gr);
                    DH(6,:)=DH(6,:)+j(indexes.(gr));
                    % reshape dh table 
                    s = size(DH,2);
                    as = DH(1,:); ds = DH(2,:); als = DH(4,:); ths = DH(6,:);
                    cos_als = cos(als); sin_als = sin(als); cos_ths = cos(ths); sin_ths = sin(ths);
                    tf = [ cos_ths; sin_ths; zeros(1,s); 
                        -sin_ths.*cos_als; cos_ths.*cos_als;sin_als;
                        sin_ths.*sin_als;  -cos_ths.*sin_als; cos_als; 
                        cos_ths.*as; sin_ths.*as;    ds];   
                    %% unrolled matrix multiplication
                    q11 = tf(1); q21 = tf(2); q31 = tf(3); q12 = tf(4); q22 = tf(5); q32 = tf(6);
                    q13 = tf(7); q23 = tf(8); q33 = tf(9); q14 = tf(10); q24 = tf(11); q34 = tf(12);
                    c = 1;
                    for i = 2:s
                        c = c + 12;
                        t12 = q11*tf(c+3) + q12*tf(c+4) + q13*tf(c+5);
                        t22 = q21*tf(c+3) + q22*tf(c+4) + q23*tf(c+5);
                        t32 = q31*tf(c+3) + q32*tf(c+4) + q33*tf(c+5);
                        q14 = q11*tf(c+9) + q12*tf(c+10) + q13*tf(c+11)+q14;
                        q24 = q21*tf(c+9) + q22*tf(c+10) + q23*tf(c+11)+q24;
                        q34 = q31*tf(c+9) + q32*tf(c+10) + q33*tf(c+11)+q34;
                        q13 = q11*tf(c+6) + q12*tf(c+7) + q13*tf(c+8);
                        q23 = q21*tf(c+6) + q22*tf(c+7) + q23*tf(c+8);
                        q33 = q31*tf(c+6) + q32*tf(c+7) + q33*tf(c+8);
                        q11 = q11*tf(c) + q12*tf(c+1);
                        q21 = q21*tf(c) + q22*tf(c+1);
                        q31 = q31*tf(c) + q32*tf(c+1);
                        q12 = t12; q22 = t22; q32 = t32;
                    end
                    RT = [q11, q12, q13,q14; q21, q22, q23, q24; q31, q32, q33, q34; 0,0,0,1];
                elseif type.(gr) == 1
                    pars = dh_pars.(gr)(indexes.(gr),:);
                    RT = [1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1];
                    for i=1:size(pars,1)
                        v = pars(i,4:6)';
                        th=norm(v);
                        if th>eps
                            v=v/th;
                        end
                        x=v(1);
                        y=v(2);
                        z=v(3);
                        R = [cos(th)+x^2*(1-cos(th)), x*y*(1-cos(th))-z*sin(th), x*z*(1-cos(th))+y*sin(th);
                             y*x*(1-cos(th))+z*sin(th), cos(th)+y^2*(1-cos(th)), y*z*(1-cos(th))-x*sin(th);
                             z*x*(1-cos(th))-y*sin(th), z*y*(1-cos(th))+x*sin(th), cos(th)+z^2*(1-cos(th))];
                        RT = RT * [R,pars(i,1:3)';0,0,0,1];
                    end
                else
                    pars = dh_pars.(gr)(indexes.(gr),:);
                    RT = [1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1];
                    for line=1:size(pars,1)
                       if any(isnan(pars(line,:)))
                           DH=pars(line,:)';
                           DH(6)=DH(6)+joints.(gr)(line);
                           s = size(DH,2);
                            as = DH(1,:); ds = DH(2,:); als = DH(4,:); ths = DH(6,:);
                            cos_als = cos(als); sin_als = sin(als); cos_ths = cos(ths); sin_ths = sin(ths);
                            tf = [ cos_ths; sin_ths; zeros(1,s); 
                                -sin_ths.*cos_als; cos_ths.*cos_als;sin_als;
                                sin_ths.*sin_als;  -cos_ths.*sin_als; cos_als; 
                                cos_ths.*as; sin_ths.*as;    ds];   
                            %% unrolled matrix multiplication
                            q11 = tf(1); q21 = tf(2); q31 = tf(3); q12 = tf(4); q22 = tf(5); q32 = tf(6);
                            q13 = tf(7); q23 = tf(8); q33 = tf(9); q14 = tf(10); q24 = tf(11); q34 = tf(12);
                            c = 1;
                            for i = 2:s
                                c = c + 12;
                                t12 = q11*tf(c+3) + q12*tf(c+4) + q13*tf(c+5);
                                t22 = q21*tf(c+3) + q22*tf(c+4) + q23*tf(c+5);
                                t32 = q31*tf(c+3) + q32*tf(c+4) + q33*tf(c+5);
                                q14 = q11*tf(c+9) + q12*tf(c+10) + q13*tf(c+11)+q14;
                                q24 = q21*tf(c+9) + q22*tf(c+10) + q23*tf(c+11)+q24;
                                q34 = q31*tf(c+9) + q32*tf(c+10) + q33*tf(c+11)+q34;
                                q13 = q11*tf(c+6) + q12*tf(c+7) + q13*tf(c+8);
                                q23 = q21*tf(c+6) + q22*tf(c+7) + q23*tf(c+8);
                                q33 = q31*tf(c+6) + q32*tf(c+7) + q33*tf(c+8);
                                q11 = q11*tf(c) + q12*tf(c+1);
                                q21 = q21*tf(c) + q22*tf(c+1);
                                q31 = q31*tf(c) + q32*tf(c+1);
                                q12 = t12; q22 = t22; q32 = t32;
                            end
                            RT = RT*[q11, q12, q13,q14; q21, q22, q23, q24; q31, q32, q33, q34; 0,0,0,1];
                       else
                            v = pars(line,4:6)';
                            th=norm(v);
                            if th>eps
                                v=v/th;
                            end
                            x=v(1);
                            y=v(2);
                            z=v(3);
                            R = [cos(th)+x^2*(1-cos(th)), x*y*(1-cos(th))-z*sin(th), x*z*(1-cos(th))+y*sin(th);
                                 y*x*(1-cos(th))+z*sin(th), cos(th)+y^2*(1-cos(th)), y*z*(1-cos(th))-x*sin(th);
                                 z*x*(1-cos(th))-y*sin(th), z*y*(1-cos(th))+x*sin(th), cos(th)+z^2*(1-cos(th))];
                            RT = RT * [R,pars(line,1:3)';0,0,0,1];
                       end
                    end
                end
        end
        link = parents.(gr);
        RTarm = RT*RTarm;
        if(strcmp(link.type, types.base)) % if the link is base end the computation          
            break;
        end
    end
end


