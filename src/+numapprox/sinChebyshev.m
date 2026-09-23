function y = sinChebyshev(x, degree, interval, coefficients)
%SINCHEBYSHEV Evaluate a Chebyshev approximation of sin on an interval.
arguments
    x double {mustBeReal, mustBeFinite}
    degree (1,1) double {mustBeInteger, mustBeNonnegative}
    interval (1,2) double {mustBeReal, mustBeFinite}
    coefficients (:,1) double {mustBeReal, mustBeFinite} = []
end
if interval(2) <= interval(1)
    error('numapprox:InvalidInterval','interval must satisfy interval(1) < interval(2).');
end
if isempty(coefficients)
    coefficients = numapprox.chebyshevCoefficients(@sin, interval, degree);
elseif numel(coefficients) ~= degree + 1
    error('numapprox:InvalidCoefficients','Coefficient count must equal degree + 1.');
end
t = (2*x - interval(1) - interval(2)) / (interval(2)-interval(1));
y = numapprox.clenshaw(coefficients, t);
end
