clc;
clear;
close all;

% Definindo o intervalo de K com uma resolução maior
K = linspace(0, 100, 100000);  % Aumentar a resolução para maior precisão

% Calcular os autovalores para cada K 
num_autovalores = 3;  % Número de autovalores
autovalores = zeros(length(K), num_autovalores);

autovalores_no_semi_plano_esquerdo = true(size(K));
for i = 1:length(K)
    autovalores(i, :) = calcular_autovalores(K(i));
    % verificar se estão no semiplano esquerdo
    if any(real(autovalores(i, :)) >= 0)
        autovalores_no_semi_plano_esquerdo(i) = false;
    end
end

% Plotar autovalores
figure;
hold on;

% Plotar partes reais e imaginárias dos autovalores individualmente com legendas específicas
for j = 1:num_autovalores
    plot(K, real(autovalores(:, j)), 'DisplayName', ['Autovalor ' num2str(j) ' Real']);
    plot(K, imag(autovalores(:, j)), '--', 'DisplayName', ['Autovalor ' num2str(j) ' Imaginário']);
end

xlabel('K');
ylabel('Autovalores');
title('Autovalores em função de K');
legend('show');
grid on;

faixa_de_K = K(autovalores_no_semi_plano_esquerdo);

% Faixa de Valores de K que estão no semiplano esquerdo
disp('Faixa de valores de K para os quais todos os autovalores estão no semiplano esquerdo:');
disp([num2str(min(faixa_de_K)), ' <= K <= ', num2str(max(faixa_de_K))]);

function autovalores = calcular_autovalores(K)
    % Matriz A
    A = [0 1 0; 0 0 1; -2 -K -2];
    autovalores = eig(A);
end
