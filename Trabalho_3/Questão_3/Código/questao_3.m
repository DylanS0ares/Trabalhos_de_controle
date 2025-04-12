clc; 
clear; 
close all;
%Tempo Final 
Tf = 2.5;

% Correção de fase e erro de regime permanente 
aux = 0;
esst = 0.05;
MF =50;
MG = 10;

% Definir a Função de Transferência
num = 2;
den = [1 1 0];
G = tf(num,den);

% Cálculo do ganho baseado em 25% de erro
Kv = 1 / esst; derivador = tf([1 0], 1); GKv = G * derivador; K = Kv / dcgain(GKv);

% Diagrama de Bode 
[ganho, fase] = margin(K * G); ganho = squeeze(ganho);
% Magnitude do ganho
valores_db = 20 * log10(ganho); % Converter para dB

while fase < MF || valores_db < MG
    % Margem de Ganho e Margem de Fase 
    MFutil = MF - fase + aux; alfa =(1 - sind(MFutil)) / (1 + sind(MFutil));
    
    ganho_desejado_dB = -20 * log10(1 / sqrt(alfa)); [GANHO_KG, FASE_KG,w] = bode(K * G);
    
    % Encontrar o índice da frequência mais próxima 
    [~,indice_frequencia] = min(abs(20 * log10(GANHO_KG) - ganho_desejado_dB));
    
    % Obter o ganho correspondente à frequência desejada
    Wn = w(indice_frequencia); T = 1 / (sqrt(alfa) * Wn); Wz = 1 / T; Wp = 1 /(alfa * T);
    
    % Compensador de Avanço de Fase
    Kc = K / alfa; num_Gc = [Kc, Kc *Wz]; den_Gc = [1, Wp]; Gc = tf(num_Gc, den_Gc);
    [ganho, fase] = margin(Gc * G); aux = aux + 0.01;
end

%Exibir os resultados 
disp('Ganho compensado = '); disp(20 *log10(ganho)); disp('Fase compensada = '); disp(fase);

%Diagrama de Bode
figure;
bode(G);
hold on
bode(Gc * G); legend('G(s)', 'Gc(s)*G(s)');

% Simulação e Resposta
t = 0:0.01:Tf; % Tempo de simulação
u_step = ones(size(t)); % Degrau unitário
u_ramp = t; % Rampa unitária

G_malha_fechada = feedback(G, 1);

% Sistema não compensado
[y_step_nao_compensado, ~] = step(G_malha_fechada, t);
[y_rampa_nao_compensado, ~] = lsim(G_malha_fechada, u_ramp, t);

Sist_comp_malha_fechada = feedback(Gc * G, 1);

% Sistema compensado
[y_step_compensado, ~] = step(Sist_comp_malha_fechada, t);
[y_rampa_compensado, ~] = lsim(Sist_comp_malha_fechada, u_ramp, t);
% 
Q = 1 + 0.*t;

% Plot da resposta ao degrau 
figure; 
plot(t,y_step_nao_compensado, 'b', t, y_step_compensado, 'r', t, Q, 'g');
xlabel('Tempo (s)'); 
ylabel('Resposta ao Degrau');
legend('NãoCompensado', 'Compensado', 'Entrada Degrau Unitário');

figure();
plot(t, y_rampa_nao_compensado, 'b', t,y_rampa_compensado, 'r', t, t, 'g');
xlabel('Tempo (s)');
ylabel('Resposta à Rampa');
legend('Não Compensado', 'Compensado','Entrada Rampa Unitária', 'Location', 'southeast');

% Compensador Discreto usando método de Tustin


freq_zero_dB = 6.67;

% Exibir a frequência encontrada disp('Frequência em 0 dB = ');
% disp(freq_zero_dB);

% tempo de amostragem com Tustin
Ts1 = 0.15 /freq_zero_dB;
Ts2 = 0.5 /freq_zero_dB;
Ts3 = 0.01 /freq_zero_dB;

% Intervalo de Amostragem
T1 = 0:Ts1:Tf;
T2 = 0:Ts2:Tf;
T3 = 0:Ts3:Tf;

%Planta do sistema no Tempo Discreto
G_z1= c2d(G,Ts1, 'zoh');
G_z2 = c2d(G,Ts2, 'zoh');
G_z3 = c2d(G,Ts3, 'zoh');

% Compensador no tempo discreto pelo método de Tustin
Gc_z_tustin1 = c2d(Gc, Ts1, 'tustin');
Gc_z_tustin2 = c2d(Gc, Ts2, 'tustin');
Gc_z_tustin3 = c2d(Gc, Ts3, 'tustin');

% Malha fechada com compensador e planta com realimentação unitária 
T_z_tustin1 = feedback(Gc_z_tustin1 * G_z1,1);
T_z_tustin2 = feedback(Gc_z_tustin2 * G_z2,1);
T_z_tustin3 = feedback(Gc_z_tustin3 * G_z3,1);

% Resposta ao Degrau para Sistema Discreto
figure;
step(Sist_comp_malha_fechada); % Resposta ao Degrau do Sistema Compensado Analógico
hold on;
step(T_z_tustin1,T1,'b'); % Resposta ao Degrau do Sistema Compensado Discreto - Tustin
title('Resposta ao Degrau - Efeito Tustin');
hold on;
step(T_z_tustin2,T2,'r'); % Resposta ao Degrau do Sistema Compensado Discreto - Tustin
hold on;
step(T_z_tustin3,T3,'g'); % Resposta ao Degrau do Sistema Compensado Discreto - Tustin
legend('Compensado Contínuo', 'Compensado Discreto - Tustin1', 'Compensado Discreto - Tustin2', 'Compensado Discreto - Tustin3');
xlabel('Tempo');
ylabel('c*(t)');



% Resposta à Rampa para Sistema Discreto
u_ramp_tustin1 = T1; % Rampa unitária para sistema discreto
u_ramp_tustin2 = T2; % Rampa unitária para sistema discreto 
u_ramp_tustin3 = T3; % Rampa unitária para sistema discreto

[y_rampa_tustin1, Tz1] = lsim(T_z_tustin1, u_ramp_tustin1);
[y_rampa_tustin2, Tz2] = lsim(T_z_tustin2, u_ramp_tustin2);
[y_rampa_tustin3, Tz3] = lsim(T_z_tustin3, u_ramp_tustin3);

% % Resposta à Rampa para Sistema Contínuo Compensado e o tempo discreto
% com tustin 
[y_rampa_compensado_continuo, ~] = lsim(Sist_comp_malha_fechada, u_ramp,t); 
figure();
bode(Gc * G); 
figure; 
stairs(Tz1,y_rampa_tustin1,'b');
hold on;
stairs(Tz2,y_rampa_tustin2,'r'); 
hold on; 
stairs(Tz3,y_rampa_tustin3,'g');
hold on;
plot(t, y_rampa_compensado_continuo, 'k');
xlabel('Tempo(s)');
ylabel('Resposta à Rampa'); 
legend('Tustin1', 'Tustin2', 'Tustin3','Compensado Contínuo');
title('Resposta à Rampa - Sistemas Discretos e Contínuo Compensado');
