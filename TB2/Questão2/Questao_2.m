clc;
clear;
close all;


%% Função de Transferência
% Para a primeira representação no espaço de estados

I = eye(3);
A = [-10 -3 7;18.25 6.25 -11.75;-7.25 -2.25 5.75];
B = [1;3;2];
C = [1 -2 4];
[num,den]= ss2tf(A,B,C,0);
F = tf(num,den);

% Exibir a função de transferência
disp('Função de Transferência F:');
[num_F, den_F] = tfdata(F, 'v'); % 'v' para vetor
fprintf('F(s) = (%s) / (%s)\n', poly2str(num_F, 's'), poly2str(den_F, 's'));

%%
% segunda TF
A1 = [-2 0 0;0 3 0; 0 0 1];
B1 = [1/2;-3/2;3];
C1 = [12 9 7/2];
[num1,den1] = ss2tf(A1,B1,C1,0);
F1 = tf(num1,den1);

% Exibir a função de transferência
disp('Função de Transferência F1:');
[num_F1, den_F1] = tfdata(F1, 'v'); % 'v' para vetor
fprintf('F(s) = (%s) / (%s) \n', poly2str(num_F1, 's'), poly2str(den_F1, 's'));


