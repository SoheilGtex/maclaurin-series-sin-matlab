%% 1) رسم sin(x) و چند تقریب مک‌لورین دور x = 0
clc; clear; close all;

syms x            % تعریف x به صورت متغیر نمادی (سمبولیک)
f = sin(x);       % تعریف تابع اصلی f(x) = sin(x)

% درجه‌های تقریب مک‌لورین (هرچه عدد بزرگ‌تر، جمله‌های بیشتری از سری تیلور)
orders = [2 4 6 8];

% حساب کردن چندجمله‌ای مک‌لورین برای هر درجه با تابع taylor
T = cell(size(orders));           % یک لیست (cell) برای نگه داشتن تقریب‌ها
for i = 1:numel(orders)
    T{i} = taylor(f, x, 0, 'Order', orders(i));   % تیلور حول 0 (مک‌لورین)
end

% تبدیل تابع نمادی به تابع عددی برای رسم روی نمودار
f_num = matlabFunction(f);

% تعریف بازه‌ی x برای رسم نمودار
xx = linspace(-2*pi, 2*pi, 1000);

% رسم تابع اصلی sin(x)
figure; hold on; grid on;
plot(xx, f_num(xx), 'k', 'LineWidth', 2);   % منحنی مشکی: خود sin(x)

% رسم تقریب‌های مک‌لورین با رنگ‌های مختلف
colors = {'r--','g--','b--','m--'};
for i = 1:numel(orders)
    T_num = matlabFunction(T{i});          % تبدیل تقریب iام به تابع عددی
    plot(xx, T_num(xx), colors{i}, 'LineWidth', 1.4);
end

legend('sin(x)', 'Taylor Order 2', 'Taylor Order 4', 'Taylor Order 6', 'Taylor Order 8', ...
    'Location', 'best');
title('Maclaurin approximation of sin(x) around 0');
xlabel('x');
ylabel('y');


%% 2) انیمیشن: زیاد شدن Order و نزدیک شدن چندجمله‌ای به sin(x)
% نکته: این بخش باید بعد از سکشن 1 اجرا شود (چون از orders ،T ،xx ،f_num استفاده می‌کند)

figure('Color','w'); grid on;
for i = 1:numel(orders)
    T_num = matlabFunction(T{i});          % تقریب مک‌لورین مربوط به این مرحله

    % رسم تابع اصلی
    plot(xx, f_num(xx), 'k', 'LineWidth', 2); hold on; grid on;

    % رسم تقریب مک‌لورین
    plot(xx, T_num(xx), 'r--', 'LineWidth', 1.8);

    title(sprintf('Maclaurin approximation of sin(x), Order = %d', orders(i)));
    legend('sin(x)', 'Maclaurin polynomial', 'Location', 'best');
    xlabel('x');
    ylabel('y');
    axis([-2*pi 2*pi -3 3]);      % ثابت نگه داشتن محدوده‌ی نمودار

    drawnow;                      % نمایش همین فریم روی شکل
    pause(0.8);                   % مکث کوتاه تا فریم دیده شود
    cla;                          % پاک کردن شکل برای فریم بعدی
end
