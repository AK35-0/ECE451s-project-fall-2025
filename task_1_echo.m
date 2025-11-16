%%% ------------- Global Variables/Intialization --------------
close all
clc

[x_n,fs] = audioread("sample_audio_file.wav");
[N,Channels] = size(x_n);

ts = 1./fs;

n = 0:(N-1);
t = n.*ts;

if (rem(N,2)==0)
    f = linspace(-fs*(0.5),fs*(0.5-1/N),N);
else
    f = linspace(-fs*(0.5-0.5/N),fs*(0.5-0.5/N),N);
end

k = f.*N./fs;

X_k = fft(x_n)./fs;

Energy_n = sum(abs(x_n(:,1)).^2);
Energy_k = sum(abs(X_k(:,1).*fs).^2)./N;

%% -----------------   TASK 1 ---------------------

bk = [1,0.9,0.8,0.7];
D = 1000;
num_samples = length(bk);
h_echo = zeros(1,N);

for i=0:(num_samples-1)
    h_echo(D*i + 1) = bk(i+1);
    fprintf("h[%d] = %2f\n",D*i,h_echo(D*i + 1));
end

%% plot

figure;
stem(n, h_echo);
title('Time Domain Echo Impulse Response');
xlabel('Discrete Time');
ylabel('Amplitude');
xlim([0 num_samples*D]);
