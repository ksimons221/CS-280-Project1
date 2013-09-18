function [ ceilrz, floorrz, leftrz, rightrz, backrz] = generateDepth( height, f, vy, floorLocation )
%generate Deapth. Generates the z coordrinates for the 5 planes
CV = f;
VA = floorLocation - vy;
VpAp = height - vy;
CVp = (CV * VpAp) /(VA);
d = CVp - CV;

ceilrz = [0, 0, d, d];
floorrz = [d, d, 0, 0];
leftrz = [0, d, d, 0];
rightrz = [d, 0, 0, d];
backrz = [d, d, d, d];

end

