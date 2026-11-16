%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Modulador AMDS usando o conceito de chave síncrona
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

%% Configurando a simulação

AMDSB_sincrono

options = simset('solver','ode45','MaxStep',0.1,'InitialStep',0.1);

[t,x,y] = sim('AMDSB_sincrono',10,options);



