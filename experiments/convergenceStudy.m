% CONVERGENCESTUDY Error versus odd Taylor degree and observed minima.
root = fileparts(fileparts(mfilename('fullpath'))); addpath(fullfile(root,'src'));
degrees = 1:2:61; xValues = [0.1, 1, 3, 7];
errors = zeros(numel(xValues), numel(degrees));
for i = 1:numel(xValues)
    for j = 1:numel(degrees)
        errors(i,j) = abs(sin(xValues(i))-numapprox.sinTaylorRecurrence(xValues(i),degrees(j)));
    end
end
[minErrors, minIndex] = min(errors,[],2); minDegrees = degrees(minIndex(:));
figure('Color','w'); semilogy(degrees,errors.','o-','LineWidth',1.2); grid on;
xlabel('Highest retained odd power'); ylabel('Absolute error');
legend('x = 0.1','x = 1','x = 3','x = 7','Location','southwest');
title('Taylor recurrence convergence and stagnation');
exportgraphics(gcf,fullfile(root,'results','figures','convergence.png'),'Resolution',180);
writematrix([degrees; errors],fullfile(root,'results','raw','convergence.csv'));
writetable(table(xValues(:),minDegrees,minErrors,'VariableNames',{'x','degreeAtMinimum','minimumAbsoluteError'}),fullfile(root,'results','reference','convergence_minima.csv'));
