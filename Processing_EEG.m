clc;
clear all;
%carica i dati in una tabella 
data_table = readtable('EEG.csv');

% Converte i dati della tabella in un vettore
data = table2array(data_table);

% Numero di campioni e frequenza di campionamento
num_campioni = size(data, 1);
frequenza_campionamento = 256; %% frequenza ottimale per campionare un segnale eeg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calcola la trasformata di Fourier per ciascun canale EEG per vedere il
% suo spettro
num_canali = size(data, 2); % Numero di colonne nella matrice data
spettro = cell(num_canali, 1);
frequenze = linspace(0, frequenza_campionamento/2, num_campioni/2 + 1);%Questa riga genera un vettore di frequenze che 
% corrispondono alle frequenze possibili nella trasformata di Fourier dello spettro. 
% La funzione linspace crea un vettore di valori equispaziati tra due estremi. 
% In questo caso, il vettore frequenze va da 0 a metà della frequenza di campionamento 
% (frequenza_campionamento/2), con un numero totale di punti pari a num_campioni/2 + 1.
% Questo perché nella trasformata di Fourier di un segnale campionato, le frequenze vanno 
% da 0 a metà della frequenza di campionamento.

for i = 1:num_canali
    spettro{i} = abs(fft(data(:, i)));
end

%%%%%%%%%%%%%%%fine parte trasformata di fourier%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(['I segnali EEG che sono di 32 pazienti che si sono sottoposti ad un esperimento ascoltando delle tracce musicali']);
canale_scelto = input('Inserisci il numero del paziente per vedere il suo EEG: ');

% Verifica che il numero del canale scelto sia valido
if canale_scelto < 1 || canale_scelto > num_canali
    error('Numero di canale non valido.');
end

% Visualizza il segnale originale e lo spettro del canale EEG scelto
figure;
subplot(2, 1, 1);
plot(data(:, canale_scelto));
xlabel('Tempo');
ylabel('Ampiezza');
title(['EEG paziente ', num2str(canale_scelto), ' (Segnale Originale)']);
grid on

subplot(2, 1, 2);
plot(frequenze, spettro{canale_scelto}(1:num_campioni/2 + 1));
xlabel('Frequenza (Hz)');
ylabel('Amplitude');
title(['Spettro EEG paziente ', num2str(canale_scelto)]);
grid on

% Definizione delle bande di frequenza (in Hz) e dei rispettivi colori
bande_frequenza = {
    'Delta', [0.5, 4], 'r';
    'Teta', [4, 8], 'g';
    'Alfa', [8, 13], 'b';
    'Beta', [13, 30], 'm';
    'Gamma', [30, 100], 'c'
};

% Evidenzia le bande di frequenza nel grafico dello spettro
hold on;

for i = 1:size(bande_frequenza, 1)
    banda = bande_frequenza{i, 2};
    % Trova gli indici delle frequenze corrispondenti alla banda
    indici_banda = find(frequenze >= banda(1) & frequenze <= banda(2));
    % Evidenzia la banda di frequenza
    area(frequenze(indici_banda), spettro{canale_scelto}(indici_banda), 'FaceColor', bande_frequenza{i, 3}, 'FaceAlpha', 0.3, 'DisplayName', bande_frequenza{i, 1});
end

hold off;

% Creazione della legenda
legend('Location', 'best');

