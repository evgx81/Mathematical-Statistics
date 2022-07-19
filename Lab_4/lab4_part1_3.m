clear
clc

% Количество выборок
l = 5;

sigma = 2;


mu1 = 10;
n1 = 50;

mu2 = 20;
n2 = 60;

mu3 = 30;
n3 = 70;

mu4 = 40;
n4 = 80;

mu5 = 50;
n5 = 90;

X_1 = random('Normal', mu1, sigma, n1, 1);
X_2 = random('Normal', mu2, sigma, n2, 1);
X_3 = random('Normal', mu3, sigma, n3, 1);
X_4 = random('Normal', mu4, sigma, n4, 1);
X_5 = random('Normal', mu5, sigma, n5, 1);

alpha = 0.05;

% Дисперсия S2_i
s2(1) = var(X_1);
s2(2) = var(X_2);
s2(3) = var(X_3);
s2(4) = var(X_4);
s2(5) = var(X_5);

% Число степеней свободы S2_i
k(1) = n1 - 1;
k(2) = n2 - 1;
k(3) = n3 - 1;
k(4) = n4 - 1;
k(5) = n5 - 1;

% Сумма степеней свободы
K = sum(k);

% Средняя арифметическая исправленных дисперсий, взвешенных по числам
% степеней свободы
S2 = sum(k .* s2)/K;

V = 2.303 * (K * log10(S2) - sum(k.* log10(s2)));
% Замечание 1:
xi_square = chi2inv(1 - alpha, l - 1);

if (V < xi_square)
    disp('Гипотеза H0: D(X_1) = D(X_2) = D(X_3) = D(X_4) = D(X_5) принимается');
else
    C = 1 + (1/(3*(l - 1))) * (sum(1./ k) - 1/K);
    B = V / C;
    if (B < xi_square)
         disp('Гипотеза H0: D(X_1) = D(X_2) = D(X_3) = D(X_4) = D(X_5) принимается');
    else
         disp('Гипотеза H0: D(X_1) = D(X_2) = D(X_3) = D(X_4) = D(X_5) отвергается');
    end
end
