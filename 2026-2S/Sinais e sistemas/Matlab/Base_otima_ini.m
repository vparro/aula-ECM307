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
% Inicializa.M

clear;clc; close all;

base_mod;

 T=1.0;         % período do sinal sob investigação
 DC=50;         % Duty-cicle do sinal pulsado
 A=2;           % Amplitude do sinal pulsado
 N=3;           % Número de harmônicas
 fase=0;        % Acerta a fase do sinal dependendo se é par ou ímpar
 M=100;          % Número de pontos
 n=1            % primeira harmônica

global c

po=0;

options = foptions([1 1e-2 1e-2 1e-2]);

fminsearch('base_otima', po ,options);



