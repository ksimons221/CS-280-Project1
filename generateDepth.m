function [depth] = generateDepth(a, h, f)
%generate Depth. Computes similar triangle calculation.
depth = f*(h/a) - f;
end

