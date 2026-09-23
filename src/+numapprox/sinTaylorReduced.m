function y = sinTaylorReduced(x, degree)
%SINTAYLORREDUCED Approximate sin(x) after quadrant range reduction.
arguments
    x double {mustBeReal, mustBeFinite}
    degree (1,1) double {mustBeInteger, mustBeNonnegative}
end
[r, quadrant] = numapprox.rangeReduce(x);
s = numapprox.sinTaylorRecurrence(r, degree);
c = numapprox.cosTaylorRecurrence(r, degree);
y = zeros(size(r));
y(quadrant == 0) = s(quadrant == 0);
y(quadrant == 1) = c(quadrant == 1);
y(quadrant == 2) = -s(quadrant == 2);
y(quadrant == 3) = -c(quadrant == 3);
end
