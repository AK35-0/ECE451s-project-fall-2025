%% Task 1: Digital Echo System
% This script implements the echo system H(z) and its equalizer G(z).

%% Load Audio Parameters

clc; clear; close all;

try
    % Load x_n (audio signal), N (length), and Fs (sampling frequency)
    load('project_parameters.mat', 'x_n', 'X_k', 'N', 'n', 'f', 'w', 'Fs', 'Energy_n');
catch
    disp('ERROR: project_parameters.mat not found. Please run task_0_audio.m first.');
    return;
end

%% 1. Digital Echo System H(z)

% System Parameters
D = 1000;
bk = [1, 0.9, 0.8, 0.7];
b_h = zeros(1, N);  % b vector for H(z)
for i=0:(length(bk)-1)
    b_h(D*i + 1) = bk(i+1);
end
a_h = 1;        % a vector for H(z)
H_z = freqz(b_h, a_h, N, 'whole');      % freq. response

% Plots for H(z)
plt_sys(b_h, a_h, N, n, f, w, 'Echo System H(z)');

% Apply H(z) to audio x[n]
Y1 = X_k .* H_z;
y1 = ifft(Y1) * Fs;
MSE_y1 = sum((y1 - x_n).^2)/(N+1);
fprintf('MSE_y1 (Echo Signal vs Original): %.3e\n', MSE_y1);

%% 2. Equalizer System G(z)

% 'a' and 'b' vectors are swapped from H(z) -> (G = 1/H)
b_g = a_h;
a_g = b_h;
G_z = freqz(b_g, a_g, N, 'whole');      % freq. response

% Plots for G(z)
plt_sys(b_g, a_g, N, n, f, w, 'Equalizer System G(z)');

% Apply G(z) to echoed signal y1[n]
Y2 = Y1 .* G_z;
y2 = ifft(Y2) * Fs;
MSE_y2 = sum((y2 - x_n).^2)/(N+1);
fprintf('MSE_y2 (Equalized Signal vs Original): %.2f\n', MSE_y2);
fprintf('----------------------------------\n');

%% You can optionally listen to the files
% soundsc(x_n, fs);
% soundsc(y1, fs);
% soundsc(y2, fs);
