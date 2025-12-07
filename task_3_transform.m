%% Task 3: Frequency Transformation
% This script transforms the Butterworth LPF from Task 2 into a HPF
% and a BPF using pole-zero rotation.

%% Load Parameters

clear; close all;

try
    % Load Fs (sampling frequency), and Butterworth LPF parameters
    load('project_parameters.mat', 'Fs', 'b_butt', 'a_butt', 'n_butt');
catch
    disp('ERROR: project_parameters.mat not found. Please run task_0_audio.m first.');
    return;
end

%% 1. LPF to HPF Transformation (Rotate by pi)

% Get the poles, zeros, and gain of the LPF
[z_lpf, p_lpf, k_lpf] = tf2zp(b_butt, a_butt);

% Rotate both poles and zeros by pi (equivalent to multiplying by -1)
z_hpf = -z_lpf;
p_hpf = -p_lpf;

% Convert HPF to (b, a) Form (no gain compensation needed)
[b_hpf, a_hpf] = zp2tf(z_hpf, p_hpf, k_lpf);

% Analyze the HPF
analyze_filter(b_hpf, a_hpf, 0, 0, 1024, Fs, 'Transsformed HPF');
fprintf('-------------------------------\n');
fprintf('-> HPF transformed successfully\n');
fprintf('-------------------------------\n\n');

%% 2. LPF to BPF Transformation (Center at pi/2)

% Rotate poles to pi/2 and -pi/2 (multiply by j, -j)
% This will double the filter order to 2 * n_butt
p_bpf = [p_lpf * 1j ; p_lpf * -1j];

% Rotate zeros to 0 and pi (multiply by 1, -1)
z_bpf = [z_lpf ; -z_lpf];

% Convert BPF to (b, a) Form (gain compensation needed)
[b_bpf, a_bpf] = zp2tf(z_bpf, p_bpf, 1);
[H_raw, f_raw] = freqz(b_bpf, a_bpf, 1024, Fs);
idx = (f_raw >= 12e3) & (f_raw <= 15e3);    % passband region
k_bpf = 1/mean(abs(H_raw(idx)));    % scaled gain factor

% Analyze the BPF
analyze_filter(k_bpf * b_bpf, a_bpf, 0, 0, 1024, Fs, 'Transsformed BPF');
fprintf('--------------------------------------------\n');
fprintf('-> BPF transformed successfully (of order %d)\n', 2*n_butt);
fprintf('--------------------------------------------\n\n');

diary off;
