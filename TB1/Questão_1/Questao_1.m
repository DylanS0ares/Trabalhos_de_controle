% Definindo a função de Transferência:
num = 1000;   % numerador
den = [1 5 104 100];   % denominador

% Função de transferência a partir da função tf
G = tf(num, den);

bode(G);



