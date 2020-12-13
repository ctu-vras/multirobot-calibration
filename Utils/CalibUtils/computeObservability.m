%% Karla Stepanova, Aug 2017

function observability = computeObservability(J,PS)
    %computes different observability parameters
    %INPUT - J - jacobian obtained via optimization process
    %       - PS - number of poses in poses set
    %OUTPUT - observability - structure containing different observability
    %indices
    %based on ftp://ftp-sop.inria.fr/members/David.Daney/articles/ijrr05.pdf
    %and Handbook of robotics
    [~,S,~] = svd (full(J'*J));
    SD = diag(S);
    %size of the hyperelipsoid
    %Borm and Menq [14.44,45], D - optimality
    if(nargin ==2)
        observability.Dopt = (prod(SD).^(1/length(SD)))/sqrt(PS);
    end
    %(sqrt(det(J'*J))).^(1/size(J,2))/sqrt(PS)
    %eccentricity of the hyperellipsoid
    observability.Ecc = SD(end)/SD(1);
    %maximizing the minimum singular value ?r - E-optimality
    observability.Min = SD(end);
    %Nahvi and Hollerbach [14.48] proposed the noise amplification index O4,which can be viewed as combining
    %the condition number Ecc with the minimum singular value Min:
    observability.O4 = SD(end)^2/SD(1);
end