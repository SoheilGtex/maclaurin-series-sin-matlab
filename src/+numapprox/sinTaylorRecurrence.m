function y = sinTaylorRecurrence(x, degree)
%SINTAYLORRECURRENCE Evaluate sin(x) using a term recurrence.
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
y = x;
term = x;
xSquared = x .* x;
if degree >= 3
    for k = 0:(degree-1)/2-1
        term = -term .* xSquared ./ ((2*k+2) * (2*k+3));
        y = y + term;
    end
end
end
