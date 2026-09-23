function coefficients = chebyshevCoefficients(fun, interval, degree)
%CHEBYSHEVCOEFFICIENTS Compute interpolatory Chebyshev coefficients.
%   The expansion convention is c(1)/2 + sum(c(k+1)T_k(t)).
arguments
    fun (1,1) function_handle
    interval (1,2) double {mustBeReal, mustBeFinite}
    degree (1,1) double {mustBeInteger, mustBeNonnegative}
end
if interval(2) <= interval(1)
    error('numapprox:InvalidInterval','interval must satisfy interval(1) < interval(2).');
end
n = degree + 1;
j = (0:n-1)';
t = cos(pi*(j + 0.5)/n);
x = (interval(1)+interval(2))/2 + (interval(2)-interval(1))/2*t;
values = fun(x);
if ~isnumeric(values) || ~isreal(values) || numel(values) ~= n || any(~isfinite(values(:)))
    error('numapprox:InvalidFunctionOutput','fun must return n finite real numeric values.');
end
values = double(values(:));
coefficients = zeros(degree+1, 1);
for k = 0:degree
    coefficients(k+1) = (2/n) * sum(values .* cos(k*pi*(j+0.5)/n));
end
end
