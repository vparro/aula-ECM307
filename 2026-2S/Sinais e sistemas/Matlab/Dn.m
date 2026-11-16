function [D] = Dn(n)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

D=3/16*[exp(-j*n*pi/4)*sinc(n/4)-exp(-j*5*n*pi/4)*sinc(3*n/4)];
end

