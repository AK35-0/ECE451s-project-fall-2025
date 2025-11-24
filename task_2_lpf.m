%% Task 2: Design of a Digital LPF
% This script designs and compares four IIR LPF types.

%% Load Audio Parameters

clc; clear; close all;

try
    % Load x_n (audio signal), N (length), and Fs (sampling frequency)
    load('project_parameters.mat', 'x_n', 'X_k', 'N', 'n', 'f', 'w', 'Fs', 'Energy_n');
catch
    disp('ERROR: project_parameters.mat not found. Please run task_0_audio.m first.');
    return;
end

%% Filter Specifications 
fp = 3000;  % Passband edge freq (Hz)
fs = 4000;  % Stopband edge freq (Hz)
Ap = 1;     % Max passband ripple (dB)
As = 50;    % Min stopband attenuation (dB)

% Normalized Frequencies
% order functions use normalized frequency (0 -> 1)
% 1 corresponds to π -> Nyquist frequency (Fs / 2)
Wp = fp / (Fs / 2);
Ws = fs / (Fs / 2);

fprintf('--- Task 2: LPF Design ---\n');
fprintf('Fs: %.0f Hz, Wp: %.3f, Ws: %.3f\n', Fs, Wp, Ws);

% Comparison storage
filter_names = {'Butterworth', 'Cheby-I', 'Cheby-II', 'Elliptic'};
filter_orders = zeros(1, 4);
filter_MSEs = zeros(1, 4);
filter_energy_loss = zeros(1, 4);

%% 1. Butterworth Filter
design_num = 1;
name = filter_names{design_num};

% minimum order
[n_butt, Wn_butt] = buttord(Wp, Ws, Ap, As);
filter_orders(design_num) = n_butt;

% filter design
[b_butt, a_butt] = butter(n_butt, Wn_butt, 'low');

% Analyze and plot
fprintf('\n--- %s Filter Analysis ---\n', name);
fprintf('Order (n): %d\n', n_butt);
[mse, energy_loss] = analyze_filter(b_butt, a_butt, x_n, Energy_n, N, f, w, name);
filter_MSEs(design_num) = mse;
filter_energy_loss(design_num) = energy_loss;

%% 2. Chebyshev Type I Filter
design_num = 2;
name = filter_names{design_num};

% minimum order
[n_cheb1, Wn_cheb1] = cheb1ord(Wp, Ws, Ap, As);
filter_orders(design_num) = n_cheb1;

% filter design
[b_cheb1, a_cheb1] = cheby1(n_cheb1, Ap, Wn_cheb1, 'low');

% Analyze and plot
fprintf('\n--- %s Filter Analysis ---\n', name);
fprintf('Order (n): %d\n', n_cheb1);
[mse, energy_loss] = analyze_filter(b_cheb1, a_cheb1, x_n, Energy_n, N, f, w, name);
filter_MSEs(design_num) = mse;
filter_energy_loss(design_num) = energy_loss;

%% 3. Chebyshev Type II Filter
design_num = 3;
name = filter_names{design_num};

% minimum order
[n_cheb2, Wn_cheb2] = cheb2ord(Wp, Ws, Ap, As);
filter_orders(design_num) = n_cheb2;

% filter design
[b_cheb2, a_cheb2] = cheby2(n_cheb2, As, Wn_cheb2, 'low');

% Analyze and plot
fprintf('\n--- %s Filter Analysis ---\n', name);
fprintf('Order (n): %d\n', n_cheb2);
[mse, energy_loss] = analyze_filter(b_cheb2, a_cheb2, x_n, Energy_n, N, f, w, name);
filter_MSEs(design_num) = mse;
filter_energy_loss(design_num) = energy_loss;

%% 4. Elliptic Filter
design_num = 4;
name = filter_names{design_num};

% minimum order
[n_ellip, Wn_ellip] = ellipord(Wp, Ws, Ap, As);
filter_orders(design_num) = n_ellip;

% filter design
[b_ellip, a_ellip] = ellip(n_ellip, Ap, As, Wn_ellip, 'low');

% Analyze and plot
fprintf('\n--- %s Filter Analysis ---\n', name);
fprintf('Order (n): %d\n', n_ellip);
[mse, energy_loss] = analyze_filter(b_ellip, a_ellip, x_n, Energy_n, N, f, w, name);
filter_MSEs(design_num) = mse;
filter_energy_loss(design_num) = energy_loss;

%% --- Final Comparison ---
fprintf('\n\n--- Filters Comparison ---\n');
T = table(filter_names', filter_orders', filter_MSEs', filter_energy_loss', ...
    'VariableNames', {'Filter Type', 'Order', 'MSE', 'Energy Loss (%)'});
disp(T);

[min_mse, idx_mse] = min(filter_MSEs);
fprintf('Filter with minimum MSE: %s Filter (MSE = %.3e)\n', filter_names{idx_mse}, min_mse);

[min_loss, idx_loss] = min(filter_energy_loss);
fprintf('Filter with minimum energy loss: %s Filter (Loss = %.2f%%)\n', filter_names{idx_loss}, min_loss);

