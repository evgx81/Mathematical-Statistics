clear
clc

mu = 2;
sigma = 4;
n1 = 100;
n2 = 150;

X = random('Normal', mu, sigma, n1, 1);
Y = random('Normal', mu, sigma, n2, 1);
alpha = 0.05;

% Исправленные выборочные дисперсии
S2_x = var(X);
S2_y = var(Y);

if (S2_x > S2_y)
    k1 = n1 - 1;
    k2 = n2 - 1;
    Fn = S2_x / S2_y;
else
    k1 = n2 - 1;
    k2 = n1 - 1;
    Fn = S2_y / S2_x;
end

% Правило 1: H1: D(X) > D(Y)
% Критическую точку найдем через обратную функцию распределения закона
% Фишера
Fk_1 = finv(1 - alpha, k1, k2); 
if (Fn < Fk_1)
    disp('Гипотеза H0: D(X) = D(Y) принимается');
elseif (Fn > Fk_1)
    disp('Гипотеза H0: D(X) = D(Y) отвергается');
end

% Правило 2: H1: D(X) != D(Y)
Fk_2 = finv(1 - (alpha / 2), k1, k2); 
if (Fn < Fk_2)
    disp('Гипотеза H0: D(X) = D(Y) принимается');
elseif (Fn > Fk_2)
    disp('Гипотеза H0: D(X) = D(Y) отвергается');
end
