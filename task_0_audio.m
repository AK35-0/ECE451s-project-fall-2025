%% Task 0: Audio File Analysis
% This script loads the audio file, plots its time and frequency
% domains, and calculates its total energy.

%% 1. Load Audio File

clc; clear; close all;

audio_path = 'sample_audio_file.wav'; % Audio file path!
try
    [x_n, Fs] = audioread(audio_path);
catch
    disp('Error: Audio file not found. Please update the audio_path variable.');
    return;
end

% If the audio is stereo (2 columns), convert it to mono by averaging
if size(x_n, 2) > 1
    x_n = mean(x_n, 2);
end

% Time domain signal
x_n = x_n(:);   % Ensure x is a column vector

% Frequency domain signal
X_k = fft(x_n)/Fs;  % scale by dt (1/Fs) -> signal is non-periodic
X_k_shifted = fftshift(X_k);    % center 0-freq. component

%% 2. Parameters Setup 
N = length(x_n);    % Total number of samples
n = 0:(N-1);        % Discrete time vector
Ts = 1/Fs;          % Time step
t = n .* Ts;        % Time vector in seconds

df = Fs/N;          % Frequency step
f_vec = n .* df;    % Frequency vector (0 -> Fs)

% Shifted Frequency vector
if (rem(N,2)==0)
    f = linspace(-Fs/2, Fs/2 - df, N); % if N is even
else
    f = linspace(-Fs/2 + df/2, Fs/2 - df/2, N); % if N is odd
end

w = 2*pi*f/Fs;  % angular frequency

fprintf('--- Task 0: Audio File Info ---\n');
fprintf('Sampling Frequency (Fs): %.0f Hz\n', Fs);
fprintf('Total Samples (N): %d\n', N);
fprintf('Duration: %.2f seconds\n', N * Ts);

%% 3. Time and Frequency domains plots

% Time domain Signal (x[n]) Plot
figure('Name', 'Audio Signal: Time Domain & Magnitude Spectrum');
subplot(1,2,1);
stem(t, x_n);
title('Time Domain Signal x[n]');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Magnitude Spectrum Plot
subplot(1,2,2)
stem(f/1000, abs(X_k_shifted));
title('Magnitude Spectrum of x[n]');
xlabel('Frequency (kHz)');
ylabel('|X(f)|');
grid on;
xlim([-15, 15]);

%% 4. Total Energy

% From Time Domain: Energy = sum(|x[n]|^2)
Energy_n = sum(abs(x_n).^2);
fprintf('Total Energy (Time Domain): %.2f\n', Energy_n);

% From Frequency Domain (Parseval's Theorem): Energy = (1/N) * sum(|X(k)|^2)
Energy_k = sum(abs(X_k * Fs).^2) / N;
fprintf('Total Energy (Frequency Domain): %.2f\n', Energy_k);
fprintf('----------------------------------\n');

%% Save Parameters for other tasks
% Save the signal x, its length N, and the sampling frequency Fs
save('project_parameters.mat', 'x_n', 'X_k', 'N', 'n', 'f', 'w', 'Fs', 'Energy_n');
