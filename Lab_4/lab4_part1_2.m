clear
clc

mu1 = 3;
sigma1 = 10;

%mu2 = 5;
%sigma2 = 9;

n1 = 100;
n2 = 150;

X = random('Normal', mu1, sigma1, n1, 1);
Y = random('Normal', mu1, sigma1, n2, 1);

% Генеральные дисперсии D(X) и D(Y) известны
D_X = sigma1*sigma1;
D_Y = sigma1*sigma1;

% Выборочные средние
M_X = mean(X);
M_Y = mean(Y);

Zn = (M_X - M_Y)/sqrt((D_X/n1) + (D_Y/n2));

alpha = 0.05;

% Правило 1: H1: M(X) != M(Y)
% (1 - alpha)/2 = 0.475
Zk_1 = 1.96;

if (abs(Zn) < Zk_1)
    disp('Гипотеза H0: M(X) = M(Y) принимается');
elseif (abs(Zn) > Zk_1)
    disp('Гипотеза H0: M(X) = M(Y) отвергается');
end

% Правило 2: H1: M(X) > M(Y)
% (1 - 2*alpha)/2 = 0.45
Zk_2 = 1.65;

if (Zn < Zk_2)
    disp('Гипотеза H0: M(X) = M(Y) принимается');
elseif (Zn > Zk_2)
    disp('Гипотеза H0: M(X) = M(Y) отвергается');
end

% Правило 3: H1: M(X) < M(Y)
% (1 - alpha)/2 = 0.475
Zk_3 = 1.96;

if (Zn > (-1)*Zk_3)
    disp('Гипотеза H0: M(X) = M(Y) принимается');
elseif (Zn < (-1)*Zk_3)
    disp('Гипотеза H0: M(X) = M(Y) отвергается');
end

