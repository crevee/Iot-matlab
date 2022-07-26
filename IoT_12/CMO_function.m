
function [A, B, C, D] = CMO_function(secretKey)

% secretKey = 3; %1 ~ 24
    M = 4; % Assumption
    tempMatrix = perms(1:M) - 1; % 1 ~ 4 ---> 0 ~ 3

    constellation_index = tempMatrix(secretKey,:);
    A = constellation_index(1);
    B = constellation_index(2);
    C = constellation_index(3);
    D = constellation_index(4);
end