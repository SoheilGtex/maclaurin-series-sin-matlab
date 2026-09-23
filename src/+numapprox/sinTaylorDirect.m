function y = sinTaylorDirect(x, degree)
%SINTAYLORDIRECT Evaluate sin(x) with the direct Maclaurin polynomial.
%   Inputs are finite real double values. degree is the highest power
%   retained; even degrees are rounded down to the preceding odd degree.
arguments
    x double {mustBeReal, mustBeFinite}
    degree (1,1) double {mustBeInteger, mustBeNonnegative}
end
if degree == 0
    y = zeros(size(x));
    return
end
degree = 2 * floor((degree - 1) / 2) + 1;
y = zeros(size(x));
for power = 1:2:degree
    y = y + (-1)^((power-1)/2) .* x.^power ./ factorial(power);
end
end
