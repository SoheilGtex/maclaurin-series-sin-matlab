function y = clenshaw(coefficients, t)
%CLENSHAW Evaluate sum_{k=0}^n a_k T_k(t) by backward recurrence.
arguments
    coefficients (:,1) double {mustBeReal, mustBeFinite}
    t double {mustBeReal, mustBeFinite}
end
n = numel(coefficients) - 1;
b1 = zeros(size(t));
b2 = zeros(size(t));
for k = n:-1:1
    b0 = 2 .* t .* b1 - b2 + coefficients(k+1);
    b2 = b1;
    b1 = b0;
end
y = t .* b1 - b2 + coefficients(1)/2;
end
