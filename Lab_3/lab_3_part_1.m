clear
clc

sigma = 3;
N = 10000;
X = random('Rayleigh', sigma, N, 1);

% 1. Критерий согласия хи-квадрат Пирсона

% Расчет гистограммы
X_min = min(X);
X_max = max(X);

r = 1 + floor(log2(N)); % Количество степеней свободы
h = (X_max - X_min) / r;
for i=1 : r+1
    z(i) = X_min + (i-1)*h; % Вектор, который содержит границы интервалов
end

z1 = z+h/2; 
z2 = z1(1:r); % Вектор, который содержит середины интервалов разбиения
U = hist(X, z2); % U определяет количество значений, попадающих в каждый интервал разбиения (относительные частоты)

% Вероятность попадания числа в i-q интервал разбиения: P = F(x1) - F(x2)
for i=1 : r
    p(i) = cdf('Rayleigh', z(i+1), sigma) - cdf('Rayleigh', z(i), sigma);
end

% Найдем хи-квадрат(наблюдаемое)
xi_square = 0; % Будет сумма r-слагаемых
for i=1 : r
    xi_square = xi_square + power((U(i) - (p(i) * N)), 2)/(p(i) * N); 
end

% Число степеней свободы - 14

alpha1 = 0.1;
alpha2 = 0.05;
alpha3 = 0.01;

% Значения в комментариях взяты из таблицы распределения хи-квадрат
xi_square_krit1 = chi2inv(1 - alpha1, r - 1); % 19.8
xi_square_krit2 = chi2inv(1 - alpha2, r - 1); % 22.4
xi_square_krit3 = chi2inv(1 - alpha3, r - 1); % 27.7
 
% 2. Критерий Колмогорова
% Теоретическая функция распределения
F = cdf('Rayleigh', z, sigma); % Теоретическая функция распределения

% Функция распределения по группированным данным
Fn(1) = 0;
for i=2 : r
    Fn(i) = Fn(i-1) + U(i-1)/N;
end
Fn(r+1) = 1;

% Ищем max|F(u) - Fn(u)|
for i=1: length(z1)
    find_abs(i) = abs(F(i) - Fn(i));
end
max_abs = max(find_abs);

d = sqrt(N) * max_abs;

% По таблице значений функции Колмогорова
d_kolmogorov1_krit = 1.23;
d_kolmogorov2_krit = 1.36;
d_kolmogorov3_krit = 1.63;