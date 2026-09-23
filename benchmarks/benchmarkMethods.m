function tableOut = benchmarkMethods
%BENCHMARKMETHODS Sweep degree, measure runtime and accuracy on a fixed grid.
root = fileparts(fileparts(mfilename('fullpath'))); addpath(fullfile(root,'src'));
x = linspace(-pi,pi,20001); degrees = 3:2:25; interval=[-pi,pi];
methodNames = {'directTaylor';'recurrenceTaylor';'reducedTaylor';'chebyshevClenshaw'};
rows = numel(methodNames)*numel(degrees); method=strings(rows,1); degree=zeros(rows,1); gridSize=zeros(rows,1); runtime=zeros(rows,1); maxError=zeros(rows,1); meanError=zeros(rows,1);
release = string(version); platform = string(computer); row=0;
for j=1:numel(degrees)
    d=degrees(j); c=numapprox.chebyshevCoefficients(@sin,interval,d);
    handles={@() numapprox.sinTaylorDirect(x,d), @() numapprox.sinTaylorRecurrence(x,d), @() numapprox.sinTaylorReduced(x,d), @() numapprox.sinChebyshev(x,d,interval,c)};
    for k=1:numel(methodNames)
        row=row+1; method(row)=methodNames{k}; degree(row)=d; gridSize(row)=numel(x); f=handles{k}; f();
        if exist('timeit','file'), runtime(row)=timeit(f); else, tic; for rep=1:10, f(); end; runtime(row)=toc/10; end
        y=f(); e=abs(sin(x)-y); maxError(row)=max(e); meanError(row)=mean(e);
    end
end
tableOut=table(method,degree,gridSize,runtime,maxError,meanError,repmat(release,rows,1),repmat(platform,rows,1), ...
    'VariableNames',{'method','degree','gridSize','runtimeSeconds','maxAbsoluteError','meanAbsoluteError','matlabRelease','platform'});
writetable(tableOut,fullfile(root,'results','raw','benchmark_sweep.csv'));
% A point is nondominated when no other point is no slower and no less accurate.
frontier=false(height(tableOut),1);
for i=1:height(tableOut)
    frontier(i)=~any(tableOut.runtimeSeconds <= tableOut.runtimeSeconds(i) & tableOut.maxAbsoluteError <= tableOut.maxAbsoluteError(i) & ...
        (tableOut.runtimeSeconds < tableOut.runtimeSeconds(i) | tableOut.maxAbsoluteError < tableOut.maxAbsoluteError(i)));
end
tableOut.nondominated=frontier; writetable(tableOut,fullfile(root,'results','reference','benchmark_sweep.csv'));
figure('Color','w'); hold on; grid on; colors=lines(numel(methodNames));
for k=1:numel(methodNames)
    mask=tableOut.method==methodNames{k}; loglog(tableOut.runtimeSeconds(mask),tableOut.maxAbsoluteError(mask),'o-','Color',colors(k,:),'DisplayName',methodNames{k});
end
mask=tableOut.nondominated; loglog(tableOut.runtimeSeconds(mask),tableOut.maxAbsoluteError(mask),'kp','MarkerFaceColor','y','DisplayName','nondominated points');
xlabel('Seconds per vector evaluation'); ylabel('Maximum absolute error'); title('Accuracy–runtime sweep'); legend('Location','southwest');
exportgraphics(gcf,fullfile(root,'results','figures','accuracy_performance.png'),'Resolution',180);
end
