clc 
close all
clear

%% x1
t_start = 0; % tempo inicial em segundos
t_end = 10;  % tempo final em segundos
n_points = 100; % número de pontos
t = linspace(t_start, t_end, n_points);
x1 = 0.66827 * exp(-0.8516 * t) -0.66827*exp(-2.348 * t);
figure;
plot(t, x1);
xlabel('Tempo (s)');
ylabel('Amplitude');
title('Função Exponencial x1');
grid on;
%% x2

t_start = 0; % tempo inicial em segundos
t_end = 10;  % tempo final em segundos
n_points = 100; % número de pontos
t = linspace(t_start, t_end, n_points);
x2 = -0.78468* exp(-0.8516 * t) +0.28468 * exp(-2.348 * t)+ (0.5);
figure;
plot(t, x2);
xlabel('Tempo (s)');
ylabel('Amplitude');
title('Função Exponencial x2');
grid on;

%% y
t_start = 0; % tempo inicial em segundos
t_end = 10;  % tempo final em segundos
n_points = 100; % número de pontos
t = linspace(t_start, t_end, n_points);
y = -(1.56936)* exp(-0.8516 * t) +(0.56936) * exp(-2.348 * t)+ (1);
figure;
plot(t, y);
xlabel('Tempo (s)');
ylabel('Amplitude');
title('Função Exponencial y');
grid on;



