function [depth] = generateDepth(a, h, f)
%generate Deapth. Generates the z coordrinates for the 5 planes
depth = f*(h/a) - f;
end

