function [D] = Dn2(n)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

D=-0.125*j*exp(-j*n*pi/4)*exp(j*4*pi)*sinc(4-n/4)+0.125*j*exp(-j*n*pi/4)*exp(-j*4*pi)*sinc(4+n/4);
end

