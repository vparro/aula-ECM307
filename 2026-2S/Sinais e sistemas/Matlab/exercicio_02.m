%% resolução do exercício 01
clear; clc;

for limite=1:2:51
    
N_neg=-limite;
N_pos= limite

N=N_pos-N_neg+1;
n=linspace(N_neg,N_pos,N);

for k=1:N
    D(k)=Dn2(n(k));
    P(k)=abs(Dn2(n(k)))^2;
end

figure(1)

stem(n,abs(D))


%% sintese

tempo=linspace(0,pi,400);

gt=0
for k=1:N
    gt=gt+D(k)*exp(j*n(k)*2.*tempo);
end

figure(2)

gref=[0.75*ones(1,100) -0.25*ones(1,300)];
plot(tempo,gt);  


figure(3)

Potencia=cumsum([P(1) 2*P(ceil(N/2):N)]);
stem(Potencia)

pause;

end

hold;
