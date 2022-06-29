clear
clc

% Распределение Рэлея: sigma = 3
sigma = 3;
% Объем выборки
N = 10000;

% 1. Сгенерировать выборку из заданного непрерывного распределения 
% объемом N=10000 с заданными для вашего распределения параметром
X = random('Rayleigh', sigma, N, 1);

%2. Найти оценку параметра заданного распределения, из которого генерировалась выборка, 
% используя метод моментов.

% Найдем оценку sigma по методу моментов
mean_val = mean(X);
% @(x) - обозначение, что уравнение зависит от переменной x(sigma)
equation = @(x) sqrt(pi/2)*x - mean_val;
sigma_MM = fzero(equation, sigma);

% Проанализируем поведение оценки параметра при изменении объема выборки
for i=1 : 1000
    X1 = random('Rayleigh', sigma, 100, 1);
    X2 = random('Rayleigh', sigma, 1000, 1);
    X3 = random('Rayleigh', sigma, 10000, 1);

    mean_val1(i) = mean(X1);
    mean_val2(i) = mean(X2);
    mean_val3(i) = mean(X3);

    equation1 = @(x) sqrt(pi/2)*x - mean_val1(i);
    equation2 = @(x) sqrt(pi/2)*x - mean_val2(i);
    equation3 = @(x) sqrt(pi/2)*x - mean_val3(i);

    sigma_MM1(i) = fzero(equation1, sigma);
    sigma_MM2(i) = fzero(equation2, sigma);
    sigma_MM3(i) = fzero(equation3, sigma);
end

figure
subplot(3, 1, 1)
plot(sigma_MM1)
hold on
yline(sigma, 'red')

subplot(3, 1, 2)
plot(sigma_MM2)
hold on
yline(sigma, 'red')

subplot(3, 1, 3)
plot(sigma_MM3)
hold on
yline(sigma, 'red')

% Вывод: при увеличении объема амплитуда разброса значений оценки уменьшается.


% 3. По заданной совокупности выборочных значений найти оценку параметра заданного
% распределения, из которого генерировалась выборка, используя метод максимального правдоподобия.

x_ = 1:0.01:10;
for i=1:length(x_)
    L(i) = -2*N*log(x_(i)) - (1/(2*(x_(i).*x_(i))))*sum(X.*X) + sum(log(X));
end
[x1, x2] = max(L);
sigma_MMP = x_(x2);

% Логарифм правдободобия
figure
plot(x_, L);

% 
% for j=1 : 1000
%     X1 = random('Rayleigh', sigma, 10, 1);
%     X2 = random('Rayleigh', sigma, 100, 1);
%     X3 = random('Rayleigh', sigma, 10000, 1);
% 
%     x_ = 1:0.01:10;
%     for i=1:length(x_)
%         L1(i) = -2*10*log(x_(i)) - (1/(2*(x_(i).*x_(i))))*sum(X1.*X1) + sum(log(X));
%         L2(i) = -2*100*log(x_(i)) - (1/(2*(x_(i).*x_(i))))*sum(X2.*X2) + sum(log(X));
%         L3(i) = -2*10000*log(x_(i)) - (1/(2*(x_(i).*x_(i))))*sum(X3.*X3) + sum(log(X));
%     end
% 
%     [x1, x10] = max(L1);
%     [x1, x20] = max(L2);
%     [x1, x30] = max(L3);
%     sigma_MMP1(j) = x_(x10);
%     sigma_MMP2(j) = x_(x20);
%     sigma_MMP3(j) = x_(x30);
% end

% figure
% subplot(3, 1, 1)
% plot(sigma_MMP1)
% hold on
% yline(sigma, 'red')
% 
% subplot(3, 1, 2)
% plot(sigma_MMP2)
% hold on
% yline(sigma, 'red')
% 
% subplot(3, 1, 3)
% plot(sigma_MMP3)
% hold on
% yline(sigma, 'red')

% 2.3. Оценить дисперсию, смещение и рассеяние оценки параметра по 100 выборочным реализациям

for i=1 : 100
    X = random('Rayleigh', sigma, N, 1);
    % Найдем оценку sigma по методу моментов
    mean_val = mean(X);
    equation = @(x) sqrt(pi/2)*x - mean_val;
    A(i) = fzero(equation, sigma);
end

% Смещение оценки
b = mean(A) - sigma;
% Рассеяние оценки
v = mean((A-sigma).^2);
% Дисперсия
d = mean((A-mean(A)).^2);

v1 = d + b.^2; 

% 3 Расчет гистограммы относительных частот

histogramm(10, sigma); % N = 10
histogramm(100, sigma); % N = 100
histogramm(10000, sigma); % N = 10000

% 4 Расчет эмперической функции распределения

emperical_function(10, sigma); % N = 10
emperical_function(100, sigma); % N = 100
emperical_function(10000, sigma); % N = 10000


function histogramm(N, sigma)
    X = random('Rayleigh', sigma, N, 1);

    X_min = min(X); % Минимальное значение выборки
    X_max = max(X); % Максимальное значение выборки

    r = 1 + floor(log2(N)); % Количество интервалов группировки(формула Стерджеса)
    h = (X_max - X_min) / r; % Ширина интервала
    for i=1 : r+1
        z(i) = X_min + (i-1)*h; % Массив границ интервалов группировки
    end

    z1 = z+h/2; 
    z2 = z1(1:r); 
    U = hist(X, z2);
    x_hist = 0:0.001:12;

    mean_val = mean(X);
    equation = @(x) sqrt(pi/2)*x - mean_val;
    sigma_MM = fzero(equation, sigma);

    % Теоретическая плотность вероятности
    f = pdf('Rayleigh', x_hist, sigma);
    % Теоретическая оценка с оценкой параметра, полученной по методу моментов
    f1 = pdf('Rayleigh', x_hist, sigma_MM);

    figure
    bar(z2, U/(h*N), 1);
    hold on
    plot(x_hist, f, 'red');
    plot(x_hist, f1, 'green');
end

function emperical_function(N, sigma)
    X = random('Rayleigh', sigma, N, 1);
    
    figure
    y = 1/N:1/N:1; % Масштаб по y
    X_sorted = sort(X); % Сортируем в порядке возрастания все значения в выборке
    stairs(X_sorted, y, 'red');

    x_hist = 0:0.001:12;

    mean_val = mean(X);
    equation = @(x) sqrt(pi/2)*x - mean_val;
    sigma_MM = fzero(equation, sigma);

    hold on
    % Теоретическая функция распределения
    func = cdf('Rayleigh', x_hist, sigma);
    plot(x_hist, func, 'blue');

    % Теоретическая функция распределения c параметром оценки по методу
    % моментов
    func1 = cdf('Rayleigh', x_hist, sigma_MM);
    plot(x_hist, func1, 'green');
end