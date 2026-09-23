function metrics = errorMetrics(reference, approximation)
%ERRORMETRICS Return absolute, safeguarded-relative, and ULP-scaled errors.
%   safeguardedRelative is not ordinary relative error near reference zeros;
%   its denominator is max(abs(reference),eps). ulpScaled uses the local
%   spacing eps(reference) and is meaningful for finite binary64 values.
arguments
    reference double {mustBeReal, mustBeFinite}
    approximation double {mustBeReal, mustBeFinite}
end
if ~isequal(size(reference), size(approximation))
    error('numapprox:SizeMismatch','reference and approximation must have the same size.');
end
absolute = abs(reference - approximation);
safeguardedRelative = absolute ./ max(abs(reference), eps);
spacing = eps(reference);
spacing(spacing == 0) = realmin;
ulpScaled = absolute ./ spacing;
metrics = struct('absolute', absolute, ...
    'safeguardedRelative', safeguardedRelative, 'relative', safeguardedRelative, ...
    'ulpScaled', ulpScaled, 'maxAbsolute', max(absolute(:)), ...
    'maxRelative', max(safeguardedRelative(:)), 'maxUlpScaled', max(ulpScaled(:)), ...
    'meanAbsolute', mean(absolute(:)), 'medianAbsolute', median(absolute(:)));
end
