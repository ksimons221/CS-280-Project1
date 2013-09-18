function [h, t] = computeH(s, d)
    % s and d are 2xN matrices, you want to compute a homography which
    % takes the source points to destination points.
    % h is the homography matrix and t is the tform returned from the
    % maketfrom function
    
    %% Write code to set up a system of equations solving which will give 
    % you the homography.
    
    %% Use maketform to generate a transformation that imtransform will 
    % understand.


    [n,m] = size(s);
    [q,r] = size(d);
    depth = d(1,2);
    
    depthRow = ones(1,r).*depth;
    
    sHomogeneous = [s; ones(1,m)];
    dHomogeneous = [d; ones(1,r)];
    dHomogeneous = dHomogeneous.*depth;
    
    h = dHomogeneous * sHomogeneous' * (sHomogeneous * sHomogeneous')^-1;
    t = maketform('projective', h');
    %return;
    
    ColumnSource1 = sHomogeneous(:,1);  
    ColumnSource2 = sHomogeneous(:,2);  
    ColumnSource3 = sHomogeneous(:,3);  
    ColumnSource4 = sHomogeneous(:,4);  

    
    
    
    sInverse = pinv(sHomogeneous);
    newh = dHomogeneous * sInverse;
    temph = mldivide(dHomogeneous, sHomogeneous);
    h = sHomogeneous\dHomogeneous;
    t = 1;
    
    n = 4;
    x = d(1, :);
    y = d(2,:); 
    X = s(1,:);
    Y = s(2,:);
rows0 = zeros(3, 4);
rowsXY = -[X; Y; ones(1,4)];
hx = [rowsXY; rows0; x.*X; x.*Y; x];
hy = [rows0; rowsXY; y.*X; y.*Y; y];
h = [hx hy];
if n == 4
    [U, ~, ~] = svd(h);
else
    [U, ~, ~] = svd(h, 'econ');
end
v = (reshape(U(:,9), 3, 3)).';
h = v./v(3,3);    

t = maketform('projective', h');



        
    
end