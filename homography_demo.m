I = imread('sjerome.jpg');

% Just so that it runs quickly..
I = imresize(I, 0.25);

% Lets say this is our homorgaphy matrix
h = [1.625 0.625 0;0.625 1.625 0;0.125 0.125 1];

% To actually be able to use it to transform images, you actually need the 
% inverse homography (that takes you from destination image to source image).
% We will not worry about it, right now, and just use the matlab function maketform
% which makes it into a transform that matlab can understand (h is a
% 'affine' transform in this case).
t = maketform('affine', h);
J = imtransform(I, t); 
figure(1); imagesc(J); axis image;

% You can also specify what part of the output space you want to get using
% xData and yData
J = imtransform(I, t,'xData', [201 350], 'yData',[251 350]); 
figure(2); imagesc(J); axis image;

% While you are developing your solution you can use a faster version,
% which uses nearest neighbor interpolation but gives worse looking
% results, you can switch back to the better looking default interpolation
% scheme for your final results.
J = imtransform(I, t, 'nearest', 'xData', [201 350], 'yData',[251 350]); 
figure(3); imagesc(J); axis image;