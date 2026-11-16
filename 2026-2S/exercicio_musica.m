%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exercício - Graves, médios e agudos com Butterworth
% Requer subst_racional.m na mesma pasta.
arquivo = 'musica.mat';             %%%%% ou musica_teste.mat
if ~exist('ouvir', 'var')
  ouvir = true;                     %%%%% false: só grava os .wav
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parte 1 - Música
load(arquivo);                      %%%%% x (amostras), fa (Hz)
x = mean(x, 2);                     %%%%% estéreo -> mono
x = x(1:min(end, 30*fa));           %%%%% no máximo 30 s

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parte 2 - Especificação
f1 = 250;                           %%%%% graves | médios (Hz)
f2 = 4000;                          %%%%% médios | agudos (Hz)
n  = 4;                             %%%%% ordem do protótipo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parte 3 - Protótipo normalizado (wc = 1)
k = 1:n;
p = exp(1j*pi*(2*k + n - 1)/(2*n)); %%%%% polos no SPE
B = real(poly(p));                  %%%%% H_N(s) = 1/B_n(s)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parte 4 - Pré-distorção (nu = f/(fa/2))
W1 = tan(pi*f1/fa);                 %%%%% W = tan(pi*nu/2)
W2 = tan(pi*f2/fa);
W0 = sqrt(W1*W2);                   %%%%% centro geométrico
Bw = W2 - W1;                       %%%%% largura da faixa

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parte 5 - Transformações em s (s <- P/Q)
[nG, dG] = subst_racional(1, B, [1 0], W1);       %%%%% PB: s/W1
[nA, dA] = subst_racional(1, B, W2, [1 0]);       %%%%% PA: W2/s
[nM, dM] = subst_racional(1, B, [1 0 W0^2], [Bw 0]); %%%%% PF

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parte 6 - Bilinear normalizada: s <- (z-1)/(z+1)
[bG, aG] = subst_racional(nG, dG, [1 -1], [1 1]);
[bM, aM] = subst_racional(nM, dM, [1 -1], [1 1]);
[bA, aA] = subst_racional(nA, dA, [1 -1], [1 1]);
bG = bG/aG(1);  aG = aG/aG(1);      %%%%% a0 = 1
bM = bM/aM(1);  aM = aM/aM(1);
bA = bA/aA(1);  aA = aA/aA(1);
fprintf('max|polo|: PB %.6f  PF %.6f  PA %.6f\n', ...
  max(abs(roots(aG))), max(abs(roots(aM))), max(abs(roots(aA))));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parte 7 - Resposta em frequência
f  = logspace(1, log10(fa/2), 500); %%%%% 10 Hz a Nyquist
z  = exp(1j*2*pi*f/fa);             %%%%% z na circunferência
HG = polyval(bG, z)./polyval(aG, z);
HM = polyval(bM, z)./polyval(aM, z);
HA = polyval(bA, z)./polyval(aA, z);
figure; semilogx(f, 20*log10(abs([HG; HM; HA])));
grid on; ylim([-80 5]); xlabel('f (Hz)'); ylabel('dB');
legend('graves', 'médios', 'agudos');
zf = exp(1j*2*pi*[f1 f2]/fa);       %%%%% confere -3 dB nos cortes
fprintf('PB(f1) %.2f PF(f1) %.2f PF(f2) %.2f PA(f2) %.2f dB\n',...
  20*log10(abs(polyval(bG, zf(1))/polyval(aG, zf(1)))), ...
  20*log10(abs(polyval(bM, zf(1))/polyval(aM, zf(1)))), ...
  20*log10(abs(polyval(bM, zf(2))/polyval(aM, zf(2)))), ...
  20*log10(abs(polyval(bA, zf(2))/polyval(aA, zf(2)))));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parte 8 - Filtrar
yG = filter(bG, aG, x);             %%%%% equação de diferenças
yM = filter(bM, aM, x);
yA = filter(bA, aA, x);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parte 9 - Espectro (FFT) antes e depois
N  = numel(x);
fk = (1:floor(N/2))*fa/N;           %%%%% bins sem o DC (eixo log)
E  = @(v) 20*log10(2*abs(v(2:floor(N/2)+1))/N + eps);
Y  = {x, yG, yM, yA};
nomes = {'original', 'graves', 'médios', 'agudos'};
figure;
for i = 1:4                         %%%%% um painel por sinal
  subplot(4, 1, i); semilogx(fk, E(fft(Y{i})));
  grid on; xlim([20 fa/2]); ylim([-140 0]); title(nomes{i});
end
xlabel('f (Hz)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parte 10 - Ouvir
s = 0.99/max(abs([yG; yM; yA]));    %%%%% mesmo ganho nas 3 faixas
audiowrite('graves.wav',  s*yG, fa);
audiowrite('medios.wav',  s*yM, fa);
audiowrite('agudos.wav',  s*yA, fa);
if ouvir
  playblocking(audioplayer(x,  fa)); %%%%% original
  playblocking(audioplayer(s*yG, fa));
  playblocking(audioplayer(s*yM, fa));
  playblocking(audioplayer(s*yA, fa));
end
