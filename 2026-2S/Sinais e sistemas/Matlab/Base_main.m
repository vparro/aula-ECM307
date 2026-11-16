%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Sintese de Fourier
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

load('coeficientes') 

 T=1.0;         % período do sinal sob investigação
 DC=50;         % Duty-cicle do sinal pulsado
 A=2;           % Amplitude do sinal pulsado
 N=3;           % Número de harmônicas
 fase=0;        % Acerta a fase do sinal dependendo se é par ou ímpar
 M=100;          % Número de pontos
 n=1            % primeira harmônica

%% Configurando a simulação

base

options = simset('solver','ode45','MaxStep',T/(200*N),'InitialStep',T/(200*N));

%% Criando o sinal

c=linspace(0,2,M);

for m=1:M
    
    c(m);
    
    [t,x,y] = sim('Base',T,options);
    
    if m==1
        
    J=y(length(y),m);
    
    end
    
    J=[J y(length(y),m)];
    
    stem(J);
end

%% determinando o valor ótimo de c

[Y,I] = min(J);

c(I)




