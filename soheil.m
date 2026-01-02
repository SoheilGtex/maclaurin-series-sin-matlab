%% DEMO: Maclaurin Series for sin(x)
% Includes:
%  1) Multiple Maclaurin polynomials overlaid on sin(x)
%  2) Approximation + absolute error plot (single chosen degree)
%  3) GIF showing convergence as degree increases
%  4) "Next-term" error proxy vs true error (comparison)
%  5) 3D surface: error vs x and number of terms (k)
%  6) Non-analytic counterexample at 0: exp(-1/x^2) (Maclaurin series fails)
%
% This script uses numeric Maclaurin construction (NO Symbolic Toolbox needed).
% Save as: maclaurin_sin_demo.m

clc; clear; close all;

%% --------- Settings ----------
% Domain for main plots
xMain   = linspace(-2*pi, 2*pi, 2000);
yMain   = sin(xMain);

% Maclaurin configuration:
% sin(x) = sum_{k=0..inf} (-1)^k x^(2k+1)/(2k+1)!
% We parameterize polynomials by k_max (highest k included).
kListOverlay = [0 1 2 3 4];   % overlays: up to x^(2k+1)
kErrorDemo   = 3;             % demo error: up to x^7 (since 2*3+1 = 7)

% GIF settings
makeGif      = true;
gifFile      = fullfile(pwd, 'maclaurin_sin.gif'); % saved in current folder
kListGif     = 0:6;           % frames: k = 0..6
gifDelaySec  = 0.8;

% 3D error surface settings
make3D       = true;
x3D          = linspace(-2*pi, 2*pi, 400);
kList3D      = 0:8;

%% 1) Overlay: sin(x) and several Maclaurin polynomials
T_overlay = cell(numel(kListOverlay), 1);

for idx = 1:numel(kListOverlay)
    kMax = kListOverlay(idx);
    T_overlay{idx} = maclaurinSinPoly(xMain, kMax);
end

figure('Color','w'); hold on; grid on;
plot(xMain, yMain, 'k', 'LineWidth', 2); % sin(x)

styles = {'r--','g--','b--','m--','c--','y--','k--'};
for idx = 1:numel(kListOverlay)
    st = styles{1 + mod(idx-1, numel(styles))};
    plot(xMain, T_overlay{idx}, st, 'LineWidth', 1.3);
end

legendText = cell(1, numel(kListOverlay) + 1);
legendText{1} = 'sin(x)';
for idx = 1:numel(kListOverlay)
    kMax = kListOverlay(idx);
    legendText{idx+1} = sprintf('Maclaurin (k=%d, up to x^{%d})', kMax, 2*kMax+1);
end

legend(legendText, 'Location', 'best');
title('Maclaurin approximations of sin(x) around 0');
xlabel('x'); ylabel('y');
axis([-2*pi 2*pi -3 3]);

%% 2) Approximation + absolute error for a chosen degree (kErrorDemo)
T_k = maclaurinSinPoly(xMain, kErrorDemo);
errAbs = abs(yMain - T_k);

figure('Color','w');

subplot(2,1,1);
plot(xMain, yMain, 'k', 'LineWidth', 2); hold on; grid on;
plot(xMain, T_k, 'r--', 'LineWidth', 1.5);
legend('sin(x)', sprintf('Maclaurin up to x^{%d}', 2*kErrorDemo+1), 'Location','best');
title(sprintf('sin(x) vs Maclaurin polynomial (k=%d)', kErrorDemo));
xlabel('x'); ylabel('y');
axis([-2*pi 2*pi -3 3]);

subplot(2,1,2);
plot(xMain, errAbs, 'b', 'LineWidth', 1.5); grid on;
title(sprintf('Absolute error: |sin(x) - T_{k}(x)| (k=%d)', kErrorDemo));
xlabel('x'); ylabel('Absolute error');

%% 3) Build a GIF showing convergence (optional)
if makeGif
    figure('Color','w');

    for frameIdx = 1:numel(kListGif)
        kMax = kListGif(frameIdx);
        Tgif = maclaurinSinPoly(linspace(-2*pi, 2*pi, 1000), kMax);
        xGif = linspace(-2*pi, 2*pi, 1000);
        yGif = sin(xGif);

        cla;
        plot(xGif, yGif, 'k', 'LineWidth', 2); hold on; grid on;
        plot(xGif, Tgif, 'r--', 'LineWidth', 1.8);
        legend('sin(x)', sprintf('Maclaurin up to x^{%d}', 2*kMax+1), 'Location','best');
        title(sprintf('Maclaurin approximation of sin(x) (k = %d)', kMax));
        xlabel('x'); ylabel('y');
        axis([-2*pi 2*pi -3 3]);

        drawnow;

        % Capture frame and append to GIF
        fr = getframe(gcf);
        im = frame2im(fr);
        [A, map] = rgb2ind(im, 256);

        if frameIdx == 1
            imwrite(A, map, gifFile, 'gif', 'LoopCount', inf, 'DelayTime', gifDelaySec);
        else
            imwrite(A, map, gifFile, 'gif', 'WriteMode', 'append', 'DelayTime', gifDelaySec);
        end
    end

    fprintf('GIF saved to: %s\n', gifFile);
end

%% 4) Next-term proxy vs true error (illustrative comparison)
% For sin(x), the next omitted term magnitude is:
% | x^(2k+3) / (2k+3)! |
% This is a useful proxy (and often close near 0), but not a strict bound for all x.

T_k = maclaurinSinPoly(xMain, kErrorDemo);
errAbs = abs(yMain - T_k);

nextTerm = abs( xMain.^(2*kErrorDemo + 3) / factorial(2*kErrorDemo + 3) );

figure('Color','w'); hold on; grid on;
plot(xMain, errAbs,   'b',  'LineWidth', 1.5);
plot(xMain, nextTerm, 'r--','LineWidth', 1.5);
legend(sprintf('|sin(x) - T_k(x)| (k=%d)', kErrorDemo), ...
       sprintf('Next-term proxy: |x^{%d}/%d!|', 2*kErrorDemo+3, 2*kErrorDemo+3), ...
       'Location','best');
title('True error vs next-term proxy (Maclaurin for sin(x))');
xlabel('x'); ylabel('Magnitude');

%% 5) 3D surface: error vs x and k (optional)
if make3D
    [X, K] = meshgrid(x3D, kList3D);
    Z = zeros(size(X));

    y3D = sin(x3D);

    for idx = 1:numel(kList3D)
        kMax = kList3D(idx);
        T3D = maclaurinSinPoly(x3D, kMax);
        Z(idx, :) = abs(y3D - T3D);
    end

    figure('Color','w');
    surf(X, K, Z);
    shading interp;
    colorbar;
    xlabel('x');
    ylabel('k (number of included terms)');
    zlabel('|sin(x) - T_k(x)|');
    title('3D error surface for Maclaurin approximation of sin(x)');
    view(135, 30);
end

%% 6) Non-analytic example at 0 (Maclaurin series fails)
% Define:
%   f(x) = exp(-1/x^2)  for x != 0
%   f(0) = 0
% All derivatives at 0 are 0 => Maclaurin series is identically 0,
% yet f(x) is not 0 for x != 0 (so the series does NOT recover the function).

f_nonanalytic = @(t) exp(-1./t.^2) .* (t ~= 0);

xNA = linspace(-1, 1, 2000);
yNA = arrayfun(f_nonanalytic, xNA);
maclaurinNA = zeros(size(xNA)); % series at 0 is 0

figure('Color','w'); hold on; grid on;
plot(xNA, yNA,        'k',  'LineWidth', 2);
plot(xNA, maclaurinNA,'r--','LineWidth', 1.5);
legend('f(x)=e^{-1/x^2} (x \neq 0), f(0)=0', 'Maclaurin series at 0 (all zeros)', ...
       'Location','best');
title('Failure of Maclaurin series for a non-analytic function at 0');
xlabel('x'); ylabel('y');
axis([-1 1 -0.1 1.1]);

%% --------- Local function ----------
function T = maclaurinSinPoly(x, kMax)
%MACLAURINSINPOLY  Maclaurin polynomial for sin(x) up to term kMax.
%   sin(x) = sum_{k=0..inf} (-1)^k * x^(2k+1)/(2k+1)!
%   This returns T(x) = sum_{k=0..kMax} ...
%
% Inputs:
%   x    : vector (or scalar) of x values
%   kMax : highest k included (k=0 gives T=x; k=1 gives x - x^3/3!, etc.)
%
% Output:
%   T    : numeric array same size as x

    T = zeros(size(x));
    for k = 0:kMax
        T = T + (-1)^k .* x.^(2*k+1) ./ factorial(2*k+1);
    end
end
