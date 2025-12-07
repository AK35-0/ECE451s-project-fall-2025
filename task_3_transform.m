clc; close all; clearvars;
try
    % Load Butterworth filter coefficients b_butt, a_butt
    load('Butterworth_filter_parameters.mat', 'b_butt', 'a_butt', 'Fs');
catch
    disp('ERROR: Butterworth_filter_parameters.mat not found. Please run task_2_lpf.m first.');
    return;
end

try
    % Load x_n (audio signal), N (length), and Fs (sampling frequency)
    load('project_parameters.mat', 'x_n', 'X_k', 'N', 'n', 'f', 'w', 'Fs', 'Energy_n');
catch
    disp('ERROR: project_parameters.mat not found. Please run task_0_audio.m first.');
    return;
end

filter_types = {'HPF Filter', 'BPF Filter'};
% 1. Get the order (length) of the coefficients
Nb = length(b_butt);
Na = length(a_butt);
na = 0:Na-1;
nb = 0:Nb-1;
% 2. Create the alternating sign vector for b_butt and a_butt
% The signs must be [ +1, -1, +1, -1, ... ]
% Since MATLAB indexing starts at 1, this corresponds to:
% Index 1 (n=0, even index) -> +1
% Index 2 (n=1, odd index) -> -1
% Index 3 (n=2, even index) -> +1
% ...
sign_b = (-1).^nb;
sign_a = (-1).^na;

% 3. Apply the LPF-to-HPF transformation by element-wise multiplication
b_hp = b_butt .* sign_b;
a_hp = a_butt .* sign_a;

% 4. Plot the original LPF and the new HPF systems for comparison

analyze_filter(b_hp, a_hp, x_n, Energy_n, N, f, w, 'hpf');

% BPF
[z_lpf, p_lpf, k_lpf] = tf2zp(b_butt, a_butt);

% Transform: z -> -z
z_hpf = -z_lpf;
p_hpf = -p_lpf;

% Scale the gain
k_hpf = k_lpf * real(prod(1-p_lpf)/prod(1-z_lpf));

% --- Convert HPF to (b, a) Form ---
[b_hpf, a_hpf] = zp2tf(z_hpf, p_hpf, k_lpf);

%% BPF
[z_lpf, p_lpf, k_lpf] = tf2zp(b_butt, a_butt);

z_bpf = [z_lpf ; -z_lpf];
p_bpf = [p_lpf * 1i ; p_lpf * -1i];

% Scale the gain
[b_raw, a_raw] = zp2tf(z_bpf, p_bpf, 1);
[H_raw, f_raw] = freqz(b_raw, a_raw, 4096, Fs);
idx = (f_raw >= 12e3) & (f_raw <= 15e3);
k_bpf = 1/mean(abs(H_raw(idx)));

% --- Convert BPF to (b, a) Form ---
[b_bp, a_bp] = zp2tf(z_bpf, p_bpf, k_bpf);

analyze_filter(b_bp, a_bp, x_n, Energy_n, N, f, w, 'BPF');
