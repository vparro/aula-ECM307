%% particionarBanco.m - gera trechos curtos e estaveis de cada vogal
% Le os audios de <pastaBase>\banco e salva 3 trechos de 0,1 s de cada um
% em <pastaBase>\banco_trechos.  Ex.: LOG_A_1.wav -> LOG_A_1_1.wav, _2, _3
clear; close all; clc;

% ---------------- Pastas ----------------
pastaBase    = 'C:\Users\lucca\OneDrive\Documentos\MATLAB';
pastaEntrada = fullfile(pastaBase, 'banco');          % audios originais
pastaSaida   = fullfile(pastaBase, 'banco_trechos');  % trechos gerados

% ---------------- Parametros ----------------
fsAlvo       = 44100;            % taxa de amostragem (Hz)
cortaInicio  = 0.250;            % descarta o ataque (s)
cortaFim     = 0.400;            % descarta a cauda (s)
limiar       = 0.15;             % fracao do pico da envoltoria = inicio/fim do som
durTrecho    = 0.100;            % duracao de cada trecho (s)
nTrechos     = 3;                % trechos por audio
sepTrechos   = 0.300;            % distancia minima entre inicios (s)
janela       = 0.020;            % sub-janela de energia (s)
hop          = 0.005;            % passo da busca (s)

% ---------------- Lista de audios ----------------
assert(exist(pastaEntrada,'dir') == 7, 'Pasta nao encontrada: %s', pastaEntrada);
if ~exist(pastaSaida, 'dir'), mkdir(pastaSaida); end

ext = {'wav','mp3','flac','m4a','ogg'};
L = [];
for e = ext
    L = [L; dir(fullfile(pastaEntrada, '**', ['*.' e{1}]))];   %#ok<AGROW> inclui subpastas
end
fprintf('%d audios encontrados em %s\n', numel(L), pastaEntrada);
nSalvos = 0;

for k = 1:numel(L)
    [~, nome] = fileparts(L(k).name);

    % --- leitura: mono, 44,1 kHz, sem DC ---
    [x, fs] = audioread(fullfile(L(k).folder, L(k).name));
    if size(x,2) > 1, x = mean(x,2); end
    x = double(x(:));
    if fs ~= fsAlvo
        [p,q] = rat(fsAlvo/fs);  x = resample(x, p, q);  fs = fsAlvo;
    end
    x = x - mean(x);

    % --- inicio e fim do som pela envoltoria RMS ---
    Lj = round(janela*fs);  Hj = round(hop*fs);
    ini = 1:Hj:numel(x)-Lj+1;
    env = zeros(numel(ini),1);
    for m = 1:numel(ini)
        env(m) = sqrt(mean(x(ini(m):ini(m)+Lj-1).^2));
    end
    acima = env >= limiar*max(env);
    i1 = ini(find(acima,1,'first')) + round(cortaInicio*fs);
    i2 = ini(find(acima,1,'last')) + Lj - 1 - round(cortaFim*fs);
    nT = round(durTrecho*fs);
    if i2 - i1 + 1 < nT
        fprintf('%s: audio curto demais, ignorado\n', L(k).name);
        continue
    end
    xu = x(i1:i2);

    % --- nota de estabilidade de cada candidato de 0,1 s ---
    cand  = 1:Hj:numel(xu)-nT+1;
    score = zeros(numel(cand),1);
    nSub  = floor(nT/Lj);
    for m = 1:numel(cand)
        q = xu(cand(m):cand(m)+nSub*Lj-1);
        e = sqrt(mean(reshape(q, Lj, []).^2));   % RMS de cada sub-janela
        score(m) = std(e)/mean(e);               % 0 = energia constante
    end

    % --- escolhe os mais estaveis, separados entre si ---
    [~, ordem] = sort(score, 'ascend');
    sel = [];
    for m = ordem.'
        if all(abs(cand(m) - sel) >= round(sepTrechos*fs))
            sel(end+1) = cand(m); %#ok<AGROW>
            if numel(sel) == nTrechos, break; end
        end
    end
    sel = sort(sel);

    % --- salva: LOG_A_1.wav -> LOG_A_1_1.wav, LOG_A_1_2.wav, ... ---
    for j = 1:numel(sel)
        y = xu(sel(j):sel(j)+nT-1);
        y = 0.9*y/max(abs(y));                   % evita saturar
        audiowrite(fullfile(pastaSaida, sprintf('%s_%d.wav', nome, j)), y, fs);
        nSalvos = nSalvos + 1;
    end
    if numel(sel) < nTrechos
        fprintf('%s: so %d trechos cabem\n', L(k).name, numel(sel));
    end
end
fprintf('Pronto: %d audios lidos, %d trechos salvos em %s\n', numel(L), nSalvos, pastaSaida);