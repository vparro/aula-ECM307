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

load('coeficientes') 

%% Configurando a simulação

load('coeficientes') 

%  T=1.0;         % período do sinal sob investigação
%  DC=50;         % Duty-cicle do sinal pulsado
%  A=2;           % Amplitude do sinal pulsado
%  N=3;           % Número de harmônicas
%  fase=0;        % Acerta a fase do sinal dependendo se é par ou ímpar

%% Configurando a simulação

sintese

options = simset('solver','ode45','MaxStep',T/(200*N),'InitialStep',T/(200*N));

%% Criando o sinal

somatoria=[t t-t];

for n=1:N
    
    [t,x,y] = sim('Sintese',T,options);
    
    somatoria=y;
    
end





