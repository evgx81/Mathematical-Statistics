clear
clc

sigma = 3;
N = 10000;
X = random('Rayleigh', sigma, N, 1);
Y = random('Rayleigh', sigma, N, 1);

% Выборочные средние
X_M = mean(X);
Y_M = mean(Y);

% Исправленная выборочная дисперсия
X_D = var(X);
Y_D = var(Y);

% Оценка коэффициента корреляции
ro = (1/(N-1))*sum((X-X_M).*(Y-Y_M))/(sqrt(X_D)*sqrt(Y_D));

% Вывод: статистисческая зависимость отсутствует 

% Статистика Т
T = (ro*sqrt(N-2))/sqrt(1-ro*ro);

% Гипотеза: ro = 0

% Критические значения

stud_0_1 = 1.6449;
stud_0_05 = 1.9600;
stud_0_01 = 2.5758;

% Гипотеза ro = 0 принимается

[ro1, T1] = with_normal_distribution(0.001, sigma, N);
% Статистисческая зависимость присутствует
% Гипотеза ro = 0 отвергается

[ro2, T2] = with_normal_distribution(100, sigma, N);
% Статистисческая зависимость присутствует
% Гипотеза ro = 0 отвергается

[ro3, T3] = with_normal_distribution(1000, sigma, N);
% Статистисческая зависимость отсутсвует
% Гипотеза ro = 0 принимается

function [ro, T] = with_normal_distribution(s, sigma, N)
    X = random('Rayleigh', sigma, N, 1);
    b = random('Normal', 0, s, N, 1);
    Y = 2*X+b;

    X_M = mean(X);
    Y_M = mean(Y);

    X_D = var(X);
    Y_D = var(Y);

    ro = (1/(N-1))*sum((X-X_M).*(Y-Y_M))/(sqrt(X_D)*sqrt(Y_D));

    T = (ro*sqrt(N-2))/sqrt(1-ro*ro);
end