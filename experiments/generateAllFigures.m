function generateAllFigures
%GENERATEALLFIGURES Run the reproducible studies and benchmark.
%   Call after: addpath('src'); addpath('experiments'); generateAllFigures
root = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(root,'src')); addpath(fullfile(root,'benchmarks'));
for name = {'raw','reference','figures'}
    target = fullfile(root,'results',name{1});
    if ~exist(target,'dir'), mkdir(target); end
end
run(fullfile(root,'experiments','convergenceStudy.m'));
run(fullfile(root,'experiments','rangeReductionStudy.m'));
run(fullfile(root,'experiments','chebyshevStudy.m'));
run(fullfile(root,'experiments','floatingPointStudy.m'));
benchmarkMethods;
end
