% FLOATINGPOINTSTUDY Compare observed error, Taylor bounds, and roundoff scale.
root = fileparts(fileparts(mfilename('fullpath'))); addpath(fullfile(root,'src'));
degrees = 1:2:61; xValues = [0.1, 1, 3]; errors = zeros(numel(xValues),numel(degrees)); bounds = errors; floors = errors;
u = eps/2; % binary64 unit roundoff for round-to-nearest near 1
for i=1:numel(xValues)
    for j=1:numel(degrees)
        a=numapprox.sinTaylorRecurrence(xValues(i),degrees(j)); errors(i,j)=abs(sin(xValues(i))-a);
        bounds(i,j)=numapprox.taylorRemainderBound(xValues(i),degrees(j));
        floors(i,j)=u*max(1,abs(sin(xValues(i))));
    end
end
figure('Color','w'); tiledlayout(1,2);
nexttile; semilogy(degrees,errors.','LineWidth',1.1); hold on; semilogy(degrees,bounds.','--','LineWidth',1.0); semilogy(degrees,floors.',':','LineWidth',1.0); grid on; xlabel('Degree'); ylabel('Scale'); title('Observed error, bound, and roundoff scale'); legend('error 0.1','error 1','error 3','bound 0.1','bound 1','bound 3','u-scale 0.1','u-scale 1','u-scale 3','Location','southwest');
nexttile; semilogy(degrees,errors./max(bounds,realmin),'LineWidth',1.1); grid on; xlabel('Degree'); ylabel('Observed error / bound'); title('Bound diagnostic');
exportgraphics(gcf,fullfile(root,'results','figures','floating_point_study.png'),'Resolution',180);
writematrix([degrees; errors; bounds; floors],fullfile(root,'results','raw','floating_point_study.csv'));
