clc; close all; clearvars;
try
    % Load Butterworth filter coefficients b_butt, a_butt
    load('Butterworth_filter_parameters.mat', 'b_butt', 'a_butt', 'Fs');
catch
    disp('ERROR: Butterworth_filter_parameters.mat not found. Please run task_2_lpf.m first.');
    return;
end

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

figure;
subplot(2,1,1);
zplane(b_butt, a_butt);
title('Original LPF (Butterworth) Pole-Zero Plot');
grid on;

subplot(2,1,2);
zplane(b_hp, a_hp);
title('Transformed HPF Pole-Zero Plot (Rotation by 180^{\circ})');
grid on;

% Optional: Plot the frequency responses to confirm the transformation
figure;
freqz(b_butt, a_butt, 512, Fs);
hold on;
freqz(b_hp, a_hp, 512, Fs);
legend('LPF', 'HPF');
title('Frequency Response Comparison');

% BPF

theta = pi/2;

% 3. Apply the LPF-to-HPF transformation by element-wise multiplication
b_1 = b_butt .* (exp(1j .* nb.* theta));
a_1 = a_butt .* (exp(1j .* na.* theta));

a_bp = conv(a_1, conj(a_1));
b_bp = conv(b_butt, b_hp);

figure;

subplot(3,1,1);
zplane(b_butt, a_butt);
title('Original LPF (Butterworth) Pole-Zero Plot');
grid on;

subplot(2,1,2);
zplane(b_bp, a_bp);
title('Transformed BPF Pole-Zero Plot (Rotation by 90^{\circ})');
grid on;
% Optional: Plot the frequency responses to confirm the transformation
figure;
freqz(b_butt, a_butt, 512, Fs);
hold on;
freqz(b_bp, a_bp, 512, Fs);
legend('LPF', 'BPF');
title('Frequency Response Comparison');
