% Удаление элементов из workspace
clear
% Очистка введенного текста из Command Window
clc

% Распределение Рэлея: sigma = 3
sigma = 3;
% Объем выборки
N = 10000;

% 1. Сгенерировать выборку из заданного непрерывного распределения 
% объемом N=10000 с заданными для вашего распределения параметрам
X = random('Rayleigh', sigma, N, 1); % Все элементы выборки поместятся в вектор N*1

% 2. Расчет выборочных числовых характеристик

% 2.1
X_min = min(X); % Минимальное значение выборки
X_max = max(X); % Максимальное значение выборки

X_M = mean(X); % Выборочное среднее
X_D_correct = var(X); % Исправленная выборочная дисперсия
X_D_incorrect = var(X, 1); % Неисправленная выборочная дисперсия
X_sko = sqrt(X_D_correct); % Выборочное средне квадратичное отклонение

Teor_M = sqrt(pi/2)*sigma;
Teor_D = (2 - pi/2)*(sigma.^2);

% 2.2
% Вывод: значения выборочного среднего и выборочной исправленной дисперсии
% приблизительно совпадают со значениями теоретического выборочного среднего и
% теоретической выборочной дисперсией соответсвенно.

%2.3

% X1 - соответсвует выборке объема 10
% X2 - соответсвует выборке объема 50
% X3 - соответсвует выборке объема 100
% X4 - соответсвует выборке объема 10000

for i=1 : 1000
    X1 = random('Rayleigh', sigma, 10, 1);
    X2 = random('Rayleigh', sigma, 50, 1);
    X3 = random('Rayleigh', sigma, 100, 1);
    X4 = random('Rayleigh', sigma, 10000, 1);

    X1_M(i) = mean(X1);
    X2_M(i) = mean(X2);
    X3_M(i) = mean(X3);
    X4_M(i) = mean(X4);
 
    X1_D_correct(i) = var(X1);
    X2_D_correct(i) = var(X2);
    X3_D_correct(i) = var(X3);
    X4_D_correct(i) = var(X4);
end

% Выборочное среднее

figure
subplot(4, 1, 1)
plot(X1_M)
hold on
yline(Teor_M, 'red')

subplot(4, 1, 2)
plot(X2_M)
hold on
yline(Teor_M, 'red')

subplot(4, 1, 3)
plot(X3_M)
hold on
yline(Teor_M, 'red')

subplot(4, 1, 4)
plot(X4_M)
hold on
yline(Teor_M, 'red')

% Выборочная исправленная дисперсия

figure
subplot(4, 1, 1)
plot(X1_D_correct)
hold on
yline(Teor_D, 'red')

subplot(4, 1, 2)
plot(X2_D_correct)
hold on
yline(Teor_D, 'red')

subplot(4, 1, 3)
plot(X3_D_correct)
hold on
yline(Teor_D, 'red')

subplot(4, 1, 4)
plot(X4_D_correct)
hold on
yline(Teor_D, 'red')

% Вывод: при увеличении объема амплитуда разброса значений уменьшается.

% 2.4

X4_mean = sum(X4_M)/1000;
X4_var = sum(X4_D_correct)/1000;

% Вывод: среднее от выборочного среднего и среднее от исправленной выборочной дисперсии по 
% 1000 штук выборочных реализаций объемом 10000 приблизительно равны

% 3
r = 1 + floor(log2(N)); % Количество интервалов группировки(формула Стерджеса)
h = (X_max - X_min) / r; % Ширина интервала
for i=1 : r+1
    z(i) = X_min + (i-1)*h; % Массив границ интервалов группировки
end

z1 = z+h/2; % Вектор, который содержит середины интервалов
% вершины, по которым строится гистограмма
z2 = z1(1:r); % Копируем эти середины в новый вектор, кроме последнего значения
% Т.к изначально брали r+1 значение, убрав последнее значение, получим r
% столбцов в гистограмме
U = hist(X, z2); % Элементы из выборки X сортируются в r интервалов
% U определяет количество значений, попадающих в каждый интервал
% sum(U) % всего таких значений 
x_hist = 0:0.001:12;
f = pdf('Rayleigh', x_hist, sigma);

figure
bar(z2, U/(h*N), 1);
hold on
plot(x_hist, f);

% Вывод: график теоретической плотности распределения приблизительно проходит
% через середины столбцов гистограммы.
% Гистограмма является приблизительной оценкой плотности распределения
% случайной величины

% 4

X_group_M = (1/N)*sum(z2.*U); % Выборочное среднее по группированным данным
X_group_D = (1/N)*sum(((z2-X_group_M).^2).*U); % Выборочная дисперсия по группированным данным

% Вывод: Выборочное среднее и выборочная дисперсия по группированным данным
% являются грубой оценкой теоретического выборочного среднего и
% теоретической выборочной дисперсии

% 5
figure
% Функция распределния по негруппированным данным
% В негруппированных данных относительная частота появления каждого следующего значения
% будет равна 1/N, поэтому высота каждого скачка будет увеличиваться на 1/N
y = 1/N:1/N:1; % Масштаб по y
X_sorted = sort(X); % Сортируем в порядке возрастания все значения в выборке
stairs(X_sorted, y, 'red');

hold on
% Функция распределения по группированным данным
Group_F = 1:1:r; % Количество ступенек
Group_F(1) = 0;
for i= 2 : r
    Group_F(i) = Group_F(i-1) + U(i)/N;
end
Group_F(r+1) = 1;
% Эмперическая функция будет проходить через середины интревалов 
stairs(z, Group_F, 'blue');
% Теоретическая функция распределения
func = cdf('Rayleigh', x_hist, sigma);
plot(x_hist, func);


