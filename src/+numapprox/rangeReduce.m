function [r, quadrant] = rangeReduce(x)
%RANGEREDUCE Reduce finite real double x to [-pi/4, pi/4].
%   Returns x = q*pi/2 + r with quadrant = mod(q,4). The transparent
%   reducer is intended for moderate arguments, not arbitrary huge inputs.
arguments
    x double {mustBeReal, mustBeFinite}
end
q = round(x ./ (pi/2));
r = x - q .* (pi/2);
mask = r > pi/4;
r(mask) = r(mask) - pi/2;
q(mask) = q(mask) + 1;
mask = r < -pi/4;
r(mask) = r(mask) + pi/2;
q(mask) = q(mask) - 1;
quadrant = mod(q, 4);
end
