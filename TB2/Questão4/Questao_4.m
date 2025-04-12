clc;
clear;
close all;
syms s;

%% Letra a
% Definir as matrizes do espaço de estados
A = [0 1 0 0 0;
    -0.1 -0.5 0 0 0; 
     0.5 0 0 0 0; 
     0 0 10 0 0;
     0.5 1 0 0 0];

B = [0; 1; 0; 0; 0];
C = [0 0 0 1 0];
D = 0;

% Matriz de controlabilidade
U = [B A*B A^2*B A^3*B];
disp('Matriz de controlabilidade U:');
disp(U); 

% Posto da matriz de controlabilidade
posto = rank(U);
disp('Posto da matriz de controlabilidade:');
disp(posto);

% Verificar se o sistema é controlável
if posto == size(A, 1)
    disp('O sistema é controlável.');
else
    disp('O sistema não é controlável.');
end

%% Letra b
% Calcular a função de transferência a partir do espaço de estados
[num, den] = ss2tf(A, B, C, D);

% Remover termos muito pequenos do numerador
num(abs(num) < 1e-10) = 0;

F = tf(num, den);

numerador_str = poly2str(num, 's');
denominador_str = poly2str(den, 's');
F1 = sprintf('F(s) = %s / %s', numerador_str, denominador_str);
disp('Função de Transferência F(s):');
disp(F1);


% Simplificar a Função de transferencia
F2 = minreal(F);
[num_simpli, den_simpli] = tfdata(F2, 'v');

% Exibir a função de transferência simplificada
disp('Função de Transferência Simplificada G(s):');
numerador_simpli_str = poly2str(num_simpli, 's');
denominador_simpli_str = poly2str(den_simpli, 's');
F2_simplificada = sprintf('F(s) = %s / %s\n', numerador_simpli_str, denominador_simpli_str);
disp(F2_simplificada);

[A1,B1,C1,D1] = tf2ss(num_simpli,den_simpli);
% Exibir a representação no espaço de estados
disp('Representação no Espaço de Estados Nova');
disp("A =");
disp(A1);
disp("B =");
disp(B1);
disp("C =");
disp(C1);
disp("D =");
disp(D1);
%% Letra c
% Matriz de controlabilidade
U1 = [B1 A1*B1 A1^2*B1 A1^3*B1];
disp('Matriz de controlabilidade U1:');
disp(U1); 

% Posto da matriz de controlabilidade
posto = rank(U1);
disp('Posto da matriz de controlabilidade:');
disp(posto);

% Verificar se o sistema é controlável
if posto == size(A1, 1)
    disp('O sistema é controlável.');
else
    disp('O sistema não é controlável.');
end
%% letra d
autovalores_F2 = eig(F2);
disp(autovalores_F2);

%% verificando a estabilidade 
figure();
step(F2);
grid on;
title('Resposta ao Degrau de F2');
xlabel('Tempo');
ylabel('Amplitude');

figure();
rlocus(F2);
grid on;
title('Root Locus F2');
xlabel('Eixo Real');
ylabel('Eixo Imaginario');



figure();
nyquist(F2);
grid on;
title('Diagrama de Nyquist');
xlabel('Eixo Real');
ylabel('Eixo Imaginario');

disp('O sistema não é estável');