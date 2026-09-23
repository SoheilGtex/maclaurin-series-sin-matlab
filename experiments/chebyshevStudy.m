% CHEBYSHEVSTUDY Compare local Taylor and interval Chebyshev approximations.
root = fileparts(fileparts(mfilename('fullpath'))); addpath(fullfile(root,'src'));
interval = [-pi,pi]; x = linspace(interval(1),interval(2),4001);
degrees = [5 9 13 17]; maxTaylor = zeros(size(degrees)); maxCheb = maxTaylor;
figure('Color','w'); tiledlayout(2,2);
for j = 1:numel(degrees)
    d = degrees(j); c = numapprox.chebyshevCoefficients(@sin,interval,d);
    t = numapprox.sinTaylorRecurrence(x,d); q = numapprox.sinChebyshev(x,d,interval,c);
    maxTaylor(j)=max(abs(sin(x)-t)); maxCheb(j)=max(abs(sin(x)-q));
    nexttile; semilogy(x,abs(sin(x)-t),x,abs(sin(x)-q),'LineWidth',1.1); grid on;
    title(sprintf('Degree %d',d)); xlabel('x'); ylabel('Absolute error'); legend('Taylor','Chebyshev');
end
exportgraphics(gcf,fullfile(root,'results','figures','chebyshev_error_profiles.png'),'Resolution',180);
figure('Color','w'); semilogy(degrees,maxTaylor,'o-',degrees,maxCheb,'s-','LineWidth',1.2); grid on;
xlabel('Degree'); ylabel('Maximum absolute error'); legend('Taylor','Chebyshev'); title('Interval error comparison');
exportgraphics(gcf,fullfile(root,'results','figures','taylor_vs_chebyshev.png'),'Resolution',180);
summaryTable = table(degrees(:), maxTaylor(:), maxCheb(:), ...
    'VariableNames', {'degree','maxTaylorAbsoluteError','maxChebyshevAbsoluteError'});
writetable(summaryTable,fullfile(root,'results','reference','chebyshev_summary.csv'));
