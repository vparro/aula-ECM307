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
% MERITO_IDENT.M

function J = base_otima(p);

global c

clc

c = p

options = simset('solver','ode45','MaxStep',0.01,'InitialStep',0.01);

[t,x,y] = sim('base_mod',1,options);

clc

J = y(max(size(y)))
