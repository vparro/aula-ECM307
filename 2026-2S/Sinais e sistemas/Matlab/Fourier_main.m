%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Calculadora Fourier para sinais quadrados
%   
%   Vanderlei Cunha Parro - vparro@ieee.org
%   Matlab versão R2011a (MacOS)
%
%
%   Versão 1.0   Dezembro de 2011
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear; close all;

%% Configurando a simulação

 T=1.0;         % período do sinal sob investigação
 DC=50;         % Duty-cicle do sinal pulsado
 A=2;           % Amplitude do sinal pulsado
 N=20;           % Número de harmônicas
 fase=0;        % Acerta a fase do sinal dependendo se é par ou ímpar

%% Configurando a simulação

Fourier

options = simset('solver','ode45','MaxStep',T/(200*N),'InitialStep',T/(200*N));

for n=1:N

[t,x,y] = sim('Fourier',T,options);

c(n)=y(length(y));


end

%% 

stem(c);grid;

save('coeficientes');



