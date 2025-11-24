function [h_n, H_z, gd] = plt_sys(b, a, N, n, f, w, sys_name)
    % This function generates the four required plots for a given filter.

    H_z = freqz(b, a, N, 'whole');      % freq. response
    h_n = ifft(H_z);                    % impulse response
    gd = grpdelay(b, a, N, 'whole');    % group delay
    
    % Pole-Zero Plot
    figure('Name', [sys_name ': Pole-Zero Plot']);
    zplane(b, a);
    title(['Pole-Zero Plot for ', sys_name]);
    grid on;
    
    % Magnitude and Phase Response 
    figure('Name', [sys_name ': Frequency Response']);
    
    % Magnitude Plot
    subplot(2,1,1);
    plot(f, 20*log10(abs(fftshift(H_z))));
    title('Magnitude Response of Echo System H(z)');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');
    grid on;
    xlim([-100, 100]);
    
    % Phase Plot
    subplot(2,1,2);
    plot(f, unwrap(rad2deg(angle(fftshift(H_z)))));
    title(['Phase Response of ', sys_name]);
    xlabel('Frequency (Hz)');
    ylabel('Phase (degrees)');
    grid on;
    xlim([-100, 100]);
    
    % Group Delay Plot
    figure('Name', [sys_name ': Group Delay']);
    plot(w/pi, fftshift(gd))
    title(['Group Delay (Samples) for ', sys_name]);
    xlabel('Normalized Angular Frequency (\pi rad/s)');
    ylabel('Group Delay (samples)');
    grid on;
    xlim([-3 3]*1e-3)
    
    % Impulse Response Plot
    figure('Name', [sys_name ': Impulse Response']);
    stem(n, h_n);
    title(['Impulse Response for ', sys_name]);
    xlabel('Discrete Time');
    ylabel('Amplitude');
    xlim([0 50000]);
    grid on;
end