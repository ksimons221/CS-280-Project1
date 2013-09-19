function [h, t] = computeH(s, d)
    % s and d are 2xN matrices, you want to compute a homography which
    % takes the source points to destination points.
    % h is the homography matrix and t is the tform returned from the
    % maketfrom function
    
    %% Write code to set up a system of equations solving which will give 
    % you the homography.
    
    %% Use maketform to generate a transformation that imtransform will 
    % understand.

    A = [-s(1,1) -s(2,1) -1 0 0 0 d(1,1)*s(1,1) d(1,1)*s(2,1);
        0 0 0 -s(1,1) -s(2,1) -1 d(2,1)*s(1,1) d(2,1)*s(2,1);
        -s(1,2) -s(2,2) -1 0 0 0 d(1,2)*s(1,2) d(1,2)*s(2,2);
        0 0 0 -s(1,2) -s(2,2) -1 d(2,2)*s(1,2) d(2,2)*s(2,2);
        -s(1,3) -s(2,3) -1 0 0 0 d(1,3)*s(1,3) d(1,3)*s(2,3);
        0 0 0 -s(1,3) -s(2,3) -1 d(2,3)*s(1,3) d(2,3)*s(2,3);
        -s(1,4) -s(2,4) -1 0 0 0 d(1,4)*s(1,4) d(1,4)*s(2,4);
        0 0 0 -s(1,4) -s(2,4) -1 d(2,4)*s(1,4) d(2,4)*s(2,4)];
        
        
    b = [-d(1,1); -d(2,1); -d(1,2); -d(2,2); -d(1,3); -d(2,3); -d(1,4); -d(2,4)];
    h = A\b;
    h = [h; 1];
    h = reshape(h, 3, 3)';
    t = maketform('projective', h');
    
end