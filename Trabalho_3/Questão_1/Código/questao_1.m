clc;
clear;
close all;

syms k1 k2 Ke s


%% Planta 
A= [0 -250/3;500 -10];
B = [500/3;0];
C = [0 1];
D =0;
[num,den] = ss2tf(A,B,C,D);
G = tf(num,den);

%% letra b)
%polos desejados
UP =20;
Ts =0.5;
I =eye(2);
zeta = -log(UP/100)/sqrt(pi^2+(log(UP/100)^2));
wn= 4/(zeta*Ts);
den_d =[1 2*zeta*wn wn^2];
polos_desejados = roots(den_d);
p1 =polos_desejados(1,1);
p2 =polos_desejados(2,1);

K = acker(A,B,polos_desejados);

figure;
step(A-B*K,B,C,D);
title('Resposta ao degrau');


% Cálculo do erro em regime permanente do sistema controlado por 
% realimentação de estados (RE) para entrada degrau unitário
E_RE=(1/s)*(1-C*((s*I-A+B*K)^(-1))*B);
erro_RE=subs(s*E_RE,s,0);


%% letra c
I=eye(3);
% como na função de transferência da planta não possui zeros escolhemos o
% mais distante possivel dos polos dominantes , aqui foi escolhido um polo
% 10x mais distante 
p3 =10*real(p1);
polos_desejados_integral =[p1,p2,p3];
polinomio_desejado = expand(((s-p1)*(s-p2)*(s-p3)));
clear k1 k2;
syms k1 k2;
K_int=[k1,k2];
Aint =[A-B*K_int B*Ke;-C 0];
det_int_antigo = det(s*eye(3)-Aint);
Kint=[0.516,-0.49126];
Ke = 0.29553744;
Aint =[A-B*Kint B*Ke;-C 0];
det_int = det(s*eye(3)-Aint);
Cint =[C 0];
Bint=[0;0;1];
Dint=0;
figure();
step(Aint,Bint,Cint,Dint);   % resposta ao degrau do sistema com controle integral
title('Resposta ao degrau sistema com controle integral');
E_REint=(1/s)*(1-(Cint*(inv(s*I-Aint))*Bint));
erro_REint=subs(s*E_REint,s,0);

[num_int,den_int]=ss2tf(Aint,Bint,Cint,Dint);
FT_controle_integral = tf(num_int,den_int);
 


