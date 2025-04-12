clc
clear 
close all

%Valores de k1 e k2 para estabilidade
% cont = 1;
k1e = 1.5;
k2e = 1.5;

%Valores de k1 e k2 para instabilidade
% cont = 2;
k1i = 0.8;
k2i = 1;

% Definir a função de transferência G(s) em malha aberta
disp ('estável = 1 ou instável = 2');
cont = input('selecione estável ou instável : ');

if cont==1
k1 = k1e;
k2 = k2e;
end

if cont==2
k1 = k1i;
k2 = k2i;
end

num = [k1*k2 k1];
den = [1 -1 0];
G = tf(num, den);

% a. Construir os diagramas de malha aberta
figure(1);
bode(G); % Diagrama de Bode de malha aberta
title('Diagrama de Bode de Malha Aberta','Fontsize',14,'Fontname','Arial');

figure(2);
nyquist(G);

[Gm,Pm,Wcg,Wcp] = margin(G);

% Convertendo para malha fechada e plotando o diagrama de Bode
H = feedback(G, 1);
figure(3);
bode(H); % Diagrama de Bode de malha fechada
title('Diagrama de Bode de Malha Fechada','Fontsize',14,'Fontname','Arial');

% c. Apresentar a resposta ao degrau em malha fechada
if cont==1
figure(4);
step(H); % Resposta ao degrau em malha fechada
title('Resposta ao degrau em malha fechada para sistema estável','Fontsize',14,'Fontname','Arial');
end

if cont==2
figure(4);
step(H); % Resposta ao degrau em malha fechada
title('Resposta ao degrau em malha fechada para sistema instável','Fontsize',14,'Fontname','Arial');
end
if Gm>=1
    fprintf('Sistema instável');
else
    fprintf('Sistema estável');
end
