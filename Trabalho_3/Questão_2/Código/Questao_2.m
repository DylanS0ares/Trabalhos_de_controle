clc
clear
close all

syms s


%% Planta Modelada
A = [0 1 0 0; 0 0 1 0; 0 0 0 1; -2 -5 -1 -13];
B = [0; 0; 0; 1];
C = [1 0 0 0];
D = 0;
x0 =[1,0,0,0];


[nump,denp] = ss2tf(A,B,C,D);
F_planta = tf(nump,denp);



%% Polos desejados
Polos_ganho_realimentacao = [-1.4+1.4i, -1.4-1.4i, -2+1i, -2-1i];
Polos_ganho_observador = [-18+5i, -18-5i, -20, -20];

% Ganho realimentacao
K_realimentacao = acker(A, B, Polos_ganho_realimentacao);

% Ganho observador
L_observador = acker(A', C', Polos_ganho_observador)';

% Sistema apenas com controlador
Ak = A - B * K_realimentacao;
sys_realim_estado = ss(Ak, B, C, D);

%Sistema apenas com observador
Aob=A-L_observador*C;
sys_observador = ss(Aob,B,C,D);

Bob = B-K_realimentacao;
% mapa de polos e zeros sistema com controlador
figure();
pzmap(sys_realim_estado);
title("Sistema com realimentação de estados");
figure();
pzmap(sys_observador);
title("Sistema com o observador");

%verificando se os polos estão alocados corretamente:
polos_sys_realim_estado =eig(sys_realim_estado);
polos_sys_observador=eig(sys_observador);
disp(polos_sys_realim_estado);
disp(polos_sys_observador);


% função de transferencia do compensador

A_comp =A-B*K_realimentacao-L_observador*C;
[num,den] = ss2tf(A_comp,L_observador,-K_realimentacao,D);
F_comp = tf(num,den);

% Sistema completo
AA =[A-B*K_realimentacao,B*K_realimentacao;zeros(size(A)),A-L_observador*C];
xc0 = [x0,0.8,0.5,-2.4,-1.3];
A_CO = (A-B*K_realimentacao-L_observador*C);
sys_completo1 = ss(AA, eye(8), eye(8), eye(8));
[y, t, x] = initial(sys_completo1, xc0);

x1 = [1 0 0 0 0 0 0 0]*x';
x2 = [0 1 0 0 0 0 0 0]*x';
x3 = [0 0 1 0 0 0 0 0]*x';
x4 = [0 0 0 1 0 0 0 0]*x';
e1 = [0 0 0 0 1 0 0 0]*x';
e2 = [0 0 0 0 0 1 0 0]*x';
e3 = [0 0 0 0 0 0 1 0]*x';
e4 = [0 0 0 0 0 0 0 1]*x';

% Define cores para os estados e erros
cores_estados = {'b', 'g', 'r', 'c'};
cores_erros = {'m', 'y', 'k', [0.5 0 0.5]};

% variaveis de estados e erros estimados
figure
plot(t, x1, 'Color', cores_estados{1}); grid
title('Resposta à condição inicial')
ylabel('variável de estado x_1')

figure();
plot(t, e1, 'Color', cores_erros{1}); grid
title(" erro a resposta de condição inicial");
ylabel('variável de estado de erro e_1')
xlabel('t(s)')

% Comparação das respostas homogêneas do sistema apenas com controlador e do sistema com controlador-observador
figure
h1 = plot(t,x1, 'r'); % Sistema com controlador-observador em vermelho
hold on
initialplot(sys_realim_estado,x0);

title('Respostas à condição inicial')
legend('Sistema com controlador-observador','Sistema apenas com controlador')



