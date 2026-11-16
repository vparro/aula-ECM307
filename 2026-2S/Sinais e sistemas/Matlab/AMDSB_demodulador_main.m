%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   DE-Modulador AMDSB usando o conceito de elemento não linear
%   
%   Vanderlei Cunha Parro - vparro@ieee.org
%   Matlab versão R2011a (MacOS)
%
%
%   Versão 1.0   Dezembro de 2011
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear;

%% Configurando a função de transferência do filtro definido opelo usuário

Num=1; Den=[1 1];    

%% Configurando os par6ametros do elemtno não linear: quadrático

a=1; b=1; c=1

%% Configurando a simulação

AMDSB_demodulador

options = simset('solver','ode45','MaxStep',0.1,'InitialStep',0.1);

[t,x,y] = sim('AMDSB_demodulador',10,options);



