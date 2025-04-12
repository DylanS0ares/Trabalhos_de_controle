clc 
clear 
close all

aux = 0;% correção de fase
esst = (input("erro(%): ")/100);% erro definido%0.25
MF = input("Margem de Fase(º): ");% Margem de Fase definida(45) 
MG = (input("Margem de Ganho(dB): ")); %Magem de Ganho definida

% Definindo a Função de Transferencia.
num  = 10;
den = [1 11 10 0];
G = tf(num,den);
 
 
% Calculo de ganho a partir do erro de 25% 
Kv =1/esst;
derivador = tf([1 0],1);
GKv = G*derivador;
K = Kv/dcgain(GKv);
 
%Diagrama de Bode
[ganho,fase] = margin(K*G);
ganho = squeeze(ganho); % magnitude do ganho
valores_db = 20*log10(ganho); %convertendo para dB
while fase < MF || valores_db < MG
    % Margem de ganho e Margem de fase
    
    MFutil = MF-fase+aux;
    alfa = ((1- sind(MFutil))/(1+sind(MFutil)));
    
    ganho_desejado_dB = -20*log10(1/sqrt(alfa));
    [GANHO_KG,FASE_KG,w] = bode(K*G);
    % Encontrando o índice da frequência mais próxima da desejada
    [~, indice_frequencia] = min(abs(20*log10(GANHO_KG) - ganho_desejado_dB));
 
    % Obtendo o ganho correspondente à frequência desejada
    Wn = w(indice_frequencia);
 
    T = 1/(sqrt(alfa)*Wn);
    Wz = 1/T;
    Wp = 1/(alfa*T);
 
    % Compensador Avanço de Fase
    Kc = K/alfa;

    num_Gc = [Kc,Kc*Wz];
    den_Gc = [1,Wp];
    Gc = tf(num_Gc,den_Gc);
    [ganho,fase] = margin(Gc*G);
    aux = aux +0.01;
    
end

disp('ganho do compensado = ');
disp((20*log10(ganho)));
disp('fase do compensado = ');
disp(fase);

% Gráficos de Bode
 hold on;
 bode(G);
 hold on;
 bode(K*G);
 hold on;
 bode(Gc/K);
 hold on;
 bode(Gc*G);
 hold on;
 
 legend('G(s)','K*G(s)','Gc(s)/K','Gc(s)*G(s)');

% Simulação e obtenção das respostas
t = 0:0.01:10; % Tempo de simulação
u_step = ones(size(t)); % Degrau unitário
u_ramp = t; % Rampa unitária
 

G_malha_fechada = feedback(G,1);


% Sistema não compensado
[y_step_nao_compensado, ~] = step(G_malha_fechada, t);
[y_rampa_nao_compensado, ~] = lsim(G_malha_fechada, u_ramp, t);
 
Sist_comp_malha_fechada = feedback(Gc*G,1);
% Sistema compensado
[y_step_compensado, ~] = step(Sist_comp_malha_fechada, t);
[y_rampa_compensado, ~] = lsim(Sist_comp_malha_fechada, u_ramp, t);
 
Q = 1 + 0.*t;
% Plotagem dos gráficos
figure;
subplot(2,1,1);
plot(t, y_step_nao_compensado, 'b', t, y_step_compensado, 'r',t,Q,'g');
xlabel('Tempo (s)');
ylabel('Resposta ao Degrau');
legend('Não Compensado', 'Compensado','Entrada degrau unitário','Localition');
 
subplot(2,1,2);
plot(t, y_rampa_nao_compensado, 'b', t, y_rampa_compensado, 'r',t,t,'g');
xlabel('Tempo (s)');
ylabel('Resposta à Rampa');
legend('Não Compensado', 'Compensado','Entrada rampa unitária','Location','southeast');

