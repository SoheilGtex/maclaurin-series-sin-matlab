function y = cosTaylorRecurrence(x, degree)
%COSTAYLORRECURRENCE Evaluate cosine near zero by term recurrence.
arguments
    x double {mustBeReal, mustBeFinite}
    degree (1,1) double {mustBeInteger, mustBeNonnegative}
end
degree = 2 * floor(degree/2);
y = ones(size(x));
term = y;
xSquared = x .* x;
if degree >= 2
    for k = 0:degree/2-1
        term = -term .* xSquared ./ ((2*k+1)*(2*k+2));
        y = y + term;
    end
end
end
