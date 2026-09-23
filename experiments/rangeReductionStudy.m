% RANGEREDUCTIONSTUDY Compare Taylor methods on deterministic moderate arguments.
root = fileparts(fileparts(mfilename('fullpath'))); addpath(fullfile(root,'src'));
% Fixed seed-free dataset: k*pi+delta, k*pi/2+delta, and log-spaced offsets.
k = [-100 -31 -7 -2 0 3 11 47 100];
delta = [0.13 -0.21 0.07 0.31 -0.19 0.11 -0.23 0.17 -0.09];
x1 = k*pi + delta;
x2 = k*pi/2 + [-0.14 0.08 -0.22 0.16 0.05 -0.12 0.19 -0.06 0.10];
x3 = [-(10.^linspace(-1,3,9)), 10.^linspace(-1,3,9)];
values = unique([x1 x2 x3]);
direct = zeros(size(values)); recurrence = direct; reduced = direct;
for i = 1:numel(values)
    direct(i) = abs(sin(values(i))-numapprox.sinTaylorDirect(values(i),15));
    recurrence(i) = abs(sin(values(i))-numapprox.sinTaylorRecurrence(values(i),15));
    reduced(i) = abs(sin(values(i))-numapprox.sinTaylorReduced(values(i),15));
end
[~,order] = sort(abs(values)); values=values(order); direct=direct(order); recurrence=recurrence(order); reduced=reduced(order);
figure('Color','w'); semilogy(abs(values),[direct;recurrence;reduced].','o-','LineWidth',1.1); grid on;
xlabel('|x|'); ylabel('Absolute error'); legend('Direct Taylor','Recurrence Taylor','Reduced Taylor','Location','northwest');
title('Range reduction on deterministic moderate arguments');
exportgraphics(gcf,fullfile(root,'results','figures','range_reduction.png'),'Resolution',180);
writematrix([values(:), direct(:), recurrence(:), reduced(:)],fullfile(root,'results','raw','range_reduction.csv'));
