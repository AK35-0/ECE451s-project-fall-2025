%%% ------------- Global Variables/Intialization --------------
close all
clc
clear

[xstereo_n,fs] = audioread("sample_audio_file.wav");
[N,Channels] = size(xstereo_n);

x_n = xstereo_n(:,1)';

ts = 1./fs;

n = 0:(N-1);
t = n.*ts;

if (rem(N,2)==0)
    f = linspace(-fs*(0.5),fs*(0.5-1/N),N);
else
    f = linspace(-fs*(0.5-0.5/N),fs*(0.5-0.5/N),N);
end
w = 2*pi*f/fs;

X_k = fft(x_n)./fs;

Energy_n = sum(abs(x_n).^2);
Energy_k = sum(abs(X_k.*fs).^2)./N;

%% -----------------   TASK 0 ---------------------

% --- Plot Time Domain (both channels) ---
figure;
stem(t, x_n);
title('Time Domain Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

figure;
stem(f./1000, fftshift(abs(X_k)));
title('Normalized Spectrum');
xlabel('Frequency (KHz)');
ylabel('Magnitude');
xlim([-15 15]);
grid on;

% --- Verification ---
% Energy_n and Energy_k should be (almost) identical.
fprintf('Total Time-Domain Energy: %.3f\n', Energy_n);
fprintf('Total Frequency-Domain Energy: %.3f\n', Energy_k);

%% -----------------   TASK 1 ---------------------
bk = [1,0.9,0.8,0.7];
D = 1000;
num_echoes = length(bk);
h_echo = zeros(1,N);

for i=0:(num_echoes-1)
    h_echo(D*i + 1) = bk(i+1);
end

H_echo = fft(h_echo);
H_echodB = 20.*log10(abs(H_echo));
H_echoPhase = unwrap(rad2deg(angle(H_echo)));

[H_echoGD,~] = grpdelay(h_echo,1,N);
H_echoGD = H_echoGD'/fs;

Y1 = X_k .* H_echo;
y1 = ifft(Y1).*fs;

MSE_y1 = 100 * sum((y1 - x_n).^2)./(N+1);

%% System plots
figure;
stem(n, h_echo,'LineWidth',1.5);
title('Time Domain Echo Impulse Response');
xlabel('Discrete Time');
ylabel('Amplitude');
xlim([0 num_echoes*D]);
grid on;

figure;
zplane (h_echo, 1);
title('Digital Echo System Polar Plot');

figure;
subplot(2,1,1);
plot(f,H_echodB,'LineWidth',1.5);
title('Echo Magnitude Response in dB (Zoomed In)');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
xlim([-2*fs/D  2*fs/D]);
grid on;

subplot(2,1,2);
plot(f,H_echoPhase,'LineWidth',1.5);
title('Echo Phase Response (Zoomed In)');
xlabel('Frequency (Hz)');
ylabel('Phase');
xlim([-2*fs/D  2*fs/D]);
grid on;

figure;
plot(w,H_echoGD*1000,'LineWidth',1.5);
title('Echo Group Delay Response (Zoomed In)');
xlabel('Normalized Angular Frequency (rad/s)');
ylabel('Group Delay (ms)');
xlim([-i*2*pi/D  i*2*pi/D]);
grid on;

fprintf('Mean Square Error of the Echo System : %.3f%% \n', MSE_y1);

%% Equalizer
G_echo = zeros(1,N);
for l = 1:N
    G_echo(l) = (abs(H_echo(l)) > 1e-4) * 1./H_echo(l);
end
g_echo = ifft(G_echo);

G_echodB = 20.*log10(abs(G_echo));
G_echoPhase = unwrap(rad2deg(angle(G_echo)));

[G_echoGD,~] = grpdelay(1,h_echo,N);
G_echoGD = G_echoGD'/fs;

Y2 = Y1 .* G_echo;
y2 = ifft(Y2).*fs;

MSE_y2 = 100 * sum((y2 - x_n).^2)./(N+1);

%% Equalizer Plots
figure;
stem(n, g_echo,'LineWidth',1.5);
title('Time Domain Equalizer Impulse Response');
xlabel('Discrete Time');
ylabel('Amplitude');
xlim([0 50*D]);
grid on;

figure;
zplane (1, h_echo);
title('Digital Equalizer System Polar Plot');

figure;
subplot(2,1,1);
plot(f,G_echodB,'LineWidth',1.5);
title('Equalizer Magnitude Response in dB (Zoomed In)');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
xlim([-2*fs/D  2*fs/D]);
grid on;

subplot(2,1,2);
plot(f,G_echoPhase,'LineWidth',1.5);
title('Equalizer Phase Response (Zoomed In)');
xlabel('Frequency (Hz)');
ylabel('Phase');
xlim([-2*fs/D  2*fs/D]);
grid on;

figure;
plot(w,G_echoGD*1000,'LineWidth',1.5);
title('Equalizer Group Delay Response (Zoomed In)');
xlabel('Normalized Angular Frequency (rad/s)');
ylabel('Group Delay (ms)');
xlim([-i*2*pi/D  i*2*pi/D]);
grid on;

fprintf('Mean Square Error of the Equalizer System : %.3f%% \n', MSE_y2);
