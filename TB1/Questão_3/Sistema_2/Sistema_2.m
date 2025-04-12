% Definir a função de transferência G(s) em malha aberta

num = [50 400 750];
den = [1, 12, 44, 48,0];
G = tf(num, den);

% a. Construir os diagramas de Bode de malha aberta e malha fechada
figure;
bode(G); % Diagrama de Bode de malha aberta
title('Diagrama de Bode de Malha Aberta');

% Convertendo para malha fechada e plotando o diagrama de Bode
H = feedback(G, 1);
figure;
bode(H); % Diagrama de Bode de malha fechada
title('Diagrama de Bode de Malha Fechada');

% b. Utilizar métodos de resposta em frequência para estimar a ultrapassagem
% percentual, o tempo de acomodação e o instante de pico.
info = stepinfo(H);
Ultrapassagem= info.Overshoot;
Tempo_de_acomodacao = info.SettlingTime;
instante_de_pico = info.PeakTime;

fprintf('Ultrapassagem percentual: %.2f%%\n', Ultrapassagem);
fprintf('Tempo de acomodação: %.2f\n', Tempo_de_acomodacao);
fprintf('Instante de pico: %.2f\n', instante_de_pico);

% c. Apresentar a resposta ao degrau em malha fechada
figure;
step(H); % Resposta ao degrau em malha fechada
title('Resposta ao Degrau em Malha Fechada');

% d. Utilizar métodos de resposta em frequência para estimar o erro em regime
% permanente.
Gcomp = tf([1,0],1);
G1 = Gcomp*G;
error_ss = 1 / (dcgain(G1));
fprintf('Erro em regime permanente: %.4f\n', error_ss);

% e. Apresentar a resposta à rampa em malha fechada
figure;
t = 0:0.01:10;
rampa = t;
[y, t] = lsim(H, rampa, t);
plot(t, y); % Resposta à rampa em malha fechada
title('Resposta à Rampa em Malha Fechada');
xlabel('Tempo');
ylabel('Saída');
