%% Task 1: Digital Echo System
% This script implements the echo system H(z) and its equalizer G(z).

%% Load Audio Parameters

clc; clear; close all;

try
    % Load x_n (audio signal), N (length), and Fs (sampling frequency)
    load('project_parameters.mat', 'x_n', 'X_k', 'N', 'Fs', 'Energy_n');
catch
    disp('ERROR: project_parameters.mat not found. Please run task_0.m first.');
    return;
end

%% 1. Digital Echo System H(z)

% Echo System Coefficients
D = 1000;
bk = [1, 0.9, 0.8, 0.7];
a_h = 1;                % a vector for H(z)
b_h = zeros(1, 2^12);   % b vector for H(z)
for i=0:(length(bk)-1)
    b_h(D * i + 1) = bk(i+1);
end

% MSE calculation and Echo system Plots
[MSE_y1, ~] = analyze_system(b_h, a_h, x_n, 0, N, Fs, 'Echo System H(z)');
fprintf('MSE_y1 (Echo Signal vs Original): %.3e\n', MSE_y1);

%% 2. Equalizer System G(z)

% 'a' and 'b' vectors are swapped from H(z) -> (G = 1/H)
b_g = a_h;
a_g = b_h;

% MSE calculation and Equalizer system Plots
[MSE_y2, ~] = analyze_system(b_g, a_g, x_n, 0, N, Fs, 'Equalizer System G(z)');
fprintf('MSE_y2 (Equalized Signal vs Original): %.2f\n', MSE_y2);
fprintf('----------------------------------\n');

%% You can optionally listen to the files
% soundsc(x_n, fs);
% soundsc(y1, fs);
% soundsc(y2, fs);
