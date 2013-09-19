% CS280, Computer Vision, Tour Into the Picture
% HW1, Sample startup code by Alyosha Efros (so it's buggy!)
%
% We read in an image, get the 5 user-speficied points, and find
% the 5 rectangles.  

% read in sample inage
clear all;
clc;
close all;

f = 800;


%startImage = imread('sjerome.jpg');
startImage = imread('pic2.jpg');
% Run the GUI in Figure 1
figure(1);
[vx,vy,irx,iry,orx,ory] = TIP_GUI(startImage);

oldvx = vx;

oldvy = vy;
% Find the cube faces and compute the expended image
[bim,bim_alpha,vx,vy,ceilrx,ceilry,floorrx,floorry,...
    leftrx,leftry,rightrx,rightry,backrx,backry] = ...
    TIP_get5rects(startImage,vx,vy,irx,iry,orx,ory);

[ymax,xmax,cdepth] = size(bim);

depthFloor =generateDepth(abs(vy-floorry(1)),abs(vy-floorry(3)),f);
depthCeiling = generateDepth(abs(vy-ceilry(3)),abs(vy-ceilry(1)),f);
depthRight = generateDepth(abs(vx- rightrx(1)), abs(vx-rightrx(3)), f);
depthLeft = generateDepth(abs(vx- leftrx(3)), abs(vx-leftrx(1)), f);

finalDepth = max([depthFloor, depthCeiling, depthRight, depthLeft]);

widthFloor = abs(floorrx(3) - floorrx(4));
widthCeiling = abs(ceilrx(1) - ceilrx(2));

heightLeft = abs(leftry(1) - leftry(4));
heightRight = abs(rightry(2) - rightry(3));

destFloor = generateSquare(widthFloor,depthFloor);
destCeiling = generateSquare(widthCeiling,depthCeiling);
destLeft = generateSquare(depthLeft, heightLeft);
destRight = generateSquare(depthRight, heightRight);

srcFloor = [floorrx;floorry];
srcCeiling = [ceilrx; ceilry];
srcRight = [rightrx; rightry];
srcLeft = [leftrx; leftry];

[floorH, floorTran] = computeHTIM(srcFloor, destFloor);
[rightH, rightTran] = computeHTIM(srcRight, destRight);
[leftH, leftTran] = computeHTIM(srcLeft, destLeft);
[ceilH, ceilTran] = computeHTIM(srcCeiling, destCeiling);




ceilPane = imtransform(bim, ceilTran, 'XData', [destCeiling(1,1), destCeiling(1,2)], 'YData', [destCeiling(2,1), destCeiling(2,3)]);

backPane = imtransform(bim, maketform('projective', eye(3)),'XData', [backrx(1,1), backrx(1,2)], 'YData', [backry(1,1), backry(1,3)]);

floorPane = imtransform(bim, floorTran, 'XData', [destFloor(1,1), destFloor(1,2)], 'YData', [destFloor(2,1), destFloor(2,3)]);

leftPane = imtransform(bim, leftTran, 'XData', [destLeft(1,1), destLeft(1,2)], 'YData', [destLeft(2,1), destLeft(2,3)]);

rightPane = imtransform(bim, rightTran, 'XData', [destRight(1,1), destRight(1,2)], 'YData', [destRight(2,1), destRight(2,3)]);


%tempCeil = imtransform(ceilIm, maketform('projective', eye(3)));%, 'XData', [0, 2000], 'YData', [0000, 3000]);
% display the expended image
figure(2);
%imshow(floorIm);
%return

backMesh = true;
rightMesh = true;
leftMesh = true;
floorMesh = true;
ceilMesh = true;

if backMesh == true
    backPlain1 = [1 1 1; 1 1 1];
    backPlain2 = [-1 0 1; -1 0 1];
    backPlain3 = [1 1 1; -1 -1 -1];
    warp(backPlain1,backPlain2,backPlain3,backPane);
end

hold on;

if leftMesh == true
    leftPlain1 = [-1 0 1; -1 0 1];
    leftPlain2 = [-1 -1 -1; -1 -1 -1];
    leftPlain3 = [1 1 1; -1 -1 -1];
    warp(leftPlain1,leftPlain2,leftPlain3,leftPane);
end

if ceilMesh == true
    ceilPlain1 = [-1 -1 -1; 1 1 1];
    ceilPlain2 = [-1 0 1; -1 0 1];
    ceilPlain3 = [1 1 1; 1 1 1];
    warp(ceilPlain1,ceilPlain2,ceilPlain3,ceilPane);
end

if floorMesh == true
    floorPlain1 = [1 1 1; -1 -1 -1];
    floorPlain2 = [-1 0 1; -1 0 1];
    floorPlain3 = [-1 -1 -1; -1 -1 -1];
    warp(floorPlain1,floorPlain2,floorPlain3,floorPane);
end

if rightMesh == true
    rightPlain1 = [1 0 -1; 1 0 -1];
    rightPlain2 = [1 1 1; 1 1 1];
    rightPlain3 = [1 1 1; -1 -1 -1];
    warp(rightPlain1,rightPlain2,rightPlain3, rightPane);
end

%imshow(bim);
return;
% Here is one way to use the alpha channel (works for 3D plots too!)
%%alpha(bim_alpha);

% Draw the Vanishing Point and the 4 faces on the image
figure(2);
hold on;
plot(vx,vy,'w*');
plot([ceilrx ceilrx(1)], [ceilry ceilry(1)], 'y-');
plot([floorrx floorrx(1)], [floorry floorry(1)], 'm-');
plot([leftrx leftrx(1)], [leftry leftry(1)], 'c-');
plot([rightrx rightrx(1)], [rightry rightry(1)], 'g-');
hold off;

%% sample code on how to display 3D sufraces in Matlab
figure(3);
% define a surface in 3D (need at least 6 points, for some reason)
planex = [0 0 0; 0 0 0];
planey = [-1 0 1; -1 0 1];
planez = [1 1 1; 0 0 0];
% create the surface and texturemap it with a given image
warp(planex,planey,planez,bim);
% Beware that matlab has 2 axis modes, ij ans xy, be sure to check if you are using
% the right one if you get flipped results.

% some alpha-channel magic to make things transparent
alpha(bim_alpha);
alpha('texture');

% Some 3D magic...
axis equal;  % make X,Y,Z dimentions be equal
axis vis3d;  % freeze the scale for better rotations
axis off;    % turn off the stupid tick marks
camproj('perspective');  % make it a perspective projection
% use the "rotate 3D" button on the figure or do "View->Camera Toolbar"
% to rotate the figure
% or use functions campos, camtarget, camup to set camera location 
% and viewpoint from within Matlab code
