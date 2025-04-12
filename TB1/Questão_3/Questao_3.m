clc
clear 
close all

% Definir a função de transferência G(s) em malha aberta
disp('Deve ser digitado entre [] e do maior grau para o menor');
disp('Obs: não esquecer do zero');
num = input('Digite o numerador da função de transferência: ');
den = input('Digite o denominador da função de transferência: ');
G = tf(num, den);

% a. Construir os diagramas de Bode de malha aberta e malha fechada
figure;
bode(G); % Diagrama de Bode de malha aberta
title('Diagrama de Bode de Malha Aberta');

% Convertendo para malha fechada e plotando o diagrama de Bode
FTMF = feedback(G, 1);
figure;
bode(FTMF); % Diagrama de Bode de malha fechada
title('Diagrama de Bode de Malha Fechada');

% b. Utilizar métodos de resposta em frequência para estimar a ultrapassagem
% percentual, o tempo de acomodação e o instante de pico.
% função stepinfo
info = stepinfo(FTMF);
Ultrapassagem = info.Overshoot;
Tempo_de_acomodacao = info.SettlingTime;
instante_de_pico = info.PeakTime;

fprintf('Ultrapassagem percentual: %.2f%%\n', Ultrapassagem);
fprintf('Tempo de acomodação: %.2f\n', Tempo_de_acomodacao);
fprintf('Instante de pico: %.2f\n', instante_de_pico);

% c. Apresentar a resposta ao degrau em malha fechada
figure;
step(FTMF); % Resposta ao degrau em malha fechada
title('Resposta ao Degrau em Malha Fechada');

% d. Utilizar métodos de resposta em frequência para estimar o erro em regime
% permanente.
num1 = [1, 0];
den1 = 1;
derivador = tf(num1, den1);

% Obtendo as informações da resposta ao degrau
info_degrau = stepinfo(FTMF, 'SettlingTimeThreshold', 0.05);
Kp = dcgain(FTMF);
error_ssdegrau = 1 / (1 + Kp);

% Obtendo as informações da resposta à rampa
info_rampa = stepinfo(derivador * FTMF, 'SettlingTimeThreshold', 0.05);
Kv = dcgain(derivador * FTMF);
error_ssrampa = 1 / Kv;

% Obtendo as informações da resposta à parábola
info_parabola = stepinfo(derivador * derivador * FTMF, 'SettlingTimeThreshold', 0.05);
Ka = dcgain(derivador * derivador * FTMF);
error_ssparabola = 1 / Ka;

fprintf('Erro em regime permanente resposta ao degrau: %.4f\n', error_ssdegrau);
fprintf('Erro em regime permanente resposta a rampa: %.4f\n', error_ssrampa);
fprintf('Erro em regime permanente resposta a parabola: %.4f\n', error_ssparabola);

% e. Apresentar a resposta à rampa em malha fechada
%Usou Lsim
figure;
t = 0:0.01:10;
rampa = t;
[y_rampa, t_rampa] = lsim(FTMF, rampa, t);
plot(t_rampa, y_rampa); % Resposta à rampa em malha fechada
title('Resposta à Rampa em Malha Fechada');
xlabel('Tempo');
ylabel('Saída');

% Apresentar a resposta à parábola em malha fechada
figure;
t = 0:0.01:10;
parabola = t.^2;
[y_parabola, t_parabola] = lsim(FTMF, parabola, t);
plot(t_parabola, y_parabola); % Resposta à parábola em malha fechada
title('Resposta à Parábola em Malha Fechada');
xlabel('Tempo');
ylabel('Saída');

