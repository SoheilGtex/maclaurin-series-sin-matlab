function bound = taylorRemainderBound(x, degree)
%TAYLORREMAINDERBOUND Lagrange bound for the sine Taylor polynomial.
%   For the polynomial through degree m, |R_m(x)| <= |x|^(m+1)/(m+1)!,
%   because every derivative of sine has magnitude at most one.
arguments
    x double {mustBeReal, mustBeFinite}
    degree (1,1) double {mustBeInteger, mustBeNonnegative}
end
power = degree + 1;
z = abs(x);
bound = zeros(size(z));
positive = z > 0;
logBound = power .* log(z(positive)) - gammaln(power + 1);
bound(positive) = exp(logBound);
end
