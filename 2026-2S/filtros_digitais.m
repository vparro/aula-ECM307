%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filtros digitais: FIR, máscara por FFT, Butterworth,
% pre-warping, bilinear e equação de diferenças
% Testado no Octave (pkg load control); compatível com MATLAB.
clear; close all;
if exist('OCTAVE_VERSION', 'builtin'), pkg load control; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parte 1 - Resposta em frequência do FIR
b1  = [1 1 1]/3;                  %%%%% h(n) = 1/3 em n = 0,1,2
w   = linspace(0, pi, 500);
z   = exp(1j*w);                  %%%%% z sobre o círculo unitário
H1  = polyval(b1, z)./z.^2;       %%%%% (z^2+z+1)/(3z^2)
figure; plot(w, abs(H1)); grid on;
xlabel('\omega (rad/amostra)'); ylabel('|H|');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parte 2 - Sinal de teste e FFT
fs  = 10e3;  T = 1/fs;            %%%%% amostragem: 10 kHz
L   = 1000;  t = (0:L-1)'*T;      %%%%% 0,1 s: resolução 10 Hz
x   = sin(2*pi*200*t) ...         %%%%% sinal útil: 200 Hz
    + 0.5*sin(2*pi*3000*t) ...    %%%%% interferência: 3 kHz
    + 0.05*randn(L, 1);           %%%%% ruído
X   = fft(x)/(L/2);
fk  = (0:L/2)*fs/L;
figure; plot(fk, 20*log10(abs(X(1:L/2+1)))); grid on;
xlabel('f (Hz)'); ylabel('|X| (dB)');
fc  = 1e3;  Ap = 3;               %%%%% máscara: passa até 1 kHz
fr  = 3e3;  Ar = 20;              %%%%% rejeita 20 dB em 3 kHz

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parte 3 - Butterworth passa-baixas
Wc  = 2/T*tan(pi*fc*T);           %%%%% bordas pre-distorcidas
Wr  = 2/T*tan(pi*fr*T);           %%%%% (Parte 5)
N   = ceil(log10(10^(Ar/10) - 1)/(2*log10(Wr/Wc)));
s   = tf('s');
Gpb = Wc^2/(s^2 + sqrt(2)*Wc*s + Wc^2);   %%%%% N = 2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parte 4 - Passa-altas a partir do passa-baixas
Gpa = s^2/(s^2 + sqrt(2)*Wc*s + Wc^2);    %%%%% s -> Wc/s

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parte 5 - Pre-warping
fa  = Wc/(2*pi);                  %%%%% 1034 Hz no analógico
f0  = fs/pi*atan(pi*fc*T);        %%%%% sem pre-warping: -3 dB
fprintf('Wc = %.1f rad/s (%.1f Hz)  Wr = %.1f rad/s\n', ...
        Wc, fa, Wr);
fprintf('N = %d  sem pre-warping: corte em %.1f Hz\n', N, f0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parte 6 - Aproximação bilinear
Hpb = c2d(Gpb, T, 'tustin');      %%%%% s = (2/T)(z-1)/(z+1)
Hpa = c2d(Gpa, T, 'tustin');
[bpb, apb] = tfdata(Hpb, 'v');
[bpa, apa] = tfdata(Hpa, 'v');
fprintf('PB: b = %.4f %.4f %.4f  a = %.4f %.4f %.4f\n', ...
        bpb, apb);
fprintf('PA: b = %.4f %.4f %.4f\n', bpa);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parte 7 - Equação de diferenças
xx  = [0; 0; x];                  %%%%% x(-1) = x(-2) = 0
yy  = zeros(L+2, 1);              %%%%% y(-1) = y(-2) = 0
for n = 3:L+2                     %%%%% laço do processador
  yy(n) = bpb(1)*xx(n) + bpb(2)*xx(n-1) + bpb(3)*xx(n-2) ...
        - apb(2)*yy(n-1) - apb(3)*yy(n-2);
end
y   = yy(3:end);
yf  = filter(bpb, apb, x);        %%%%% conferência
e   = max(abs(y - yf));
fprintf('max |y - filter| = %.1e\n', e);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parte 8 - Tipo do filtro: H(1) e H(-1)
Hz  = @(b, a, z) polyval(b, z)/polyval(a, z);
fprintf('PB: H(1) = %.3f  H(-1) = %.3f\n', ...
        Hz(bpb, apb, 1), Hz(bpb, apb, -1));
fprintf('PA: H(1) = %.3f  H(-1) = %.3f\n', ...
        Hz(bpa, apa, 1), Hz(bpa, apa, -1));
p   = roots(apb);               %%%%% polos do PB (e do PA)
fprintf('polos: %.4f +/- %.4fj  |p| = %.4f\n', ...
        real(p(1)), abs(imag(p(1))), abs(p(1)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parte 9 - Resposta em frequência x FFT
Y   = fft(y)/(L/2);
for f0 = [200 3000]
  k  = round(f0*L/fs) + 1;
  Hm = 20*log10(abs(Y(k))/abs(X(k)));     %%%%% medido
  Ht = 20*log10(abs(Hz(bpb, apb, exp(1j*2*pi*f0*T))));
  fprintf('%4d Hz: |Y/X| = %6.2f dB  |H| = %6.2f dB\n', ...
          f0, Hm, Ht);
end
figure; plot(fk, 20*log10(abs([X(1:L/2+1) Y(1:L/2+1)]))); grid on;
xlabel('f (Hz)'); ylabel('dB'); legend('entrada', 'saída');
