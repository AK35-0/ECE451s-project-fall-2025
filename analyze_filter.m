function [mse, energy_loss] = analyze_filter(b, a, x_n, energy_x, N, fs, filter_name)
    % This function generates all plots and computes MSE/Energy Loss

    % 1. Pole-Zero Plot
    figure('Name', [filter_name ': Pole-Zero Plot']);
    zplane(b, a);
    title(['Pole-Zero Plot for ', filter_name]);
    grid on;

    % 2. Magnitude and Phase Response
    [H, w] = freqz(b, a, N, 'whole');
    w = w - pi; f = w/pi * fs/2;
    phi = unwrap(angle(fftshift(H)));
    figure('Name', [filter_name ': Frequency Response']);
    
    % Magnitude
    subplot(2,1,1);
    plot(f / 1000, 20*log10(abs(fftshift(H))));
    title(['Magnitude Response for ', filter_name]);
    xlabel('Frequency (kHz)');
    ylabel('Magnitude (dB)');
    grid on; xlim([-24 24]);
    yl = ylim; ylim([yl(1) 50]);
    
    % Phase Response
    subplot(2,1,2);
    plot(f / 1000, rad2deg(phi));
    title(['Phase Response for ', filter_name]);
    xlabel('Frequency (kHz)');
    ylabel('Phase (degrees)');
    grid on; xlim([-24, 24]);

    % 3. Group Delay
    gd = grpdelay(b, a, N, 'whole');
    figure('Name', [filter_name ': Group Delay']);
    plot(w/pi, fftshift(gd));
    title(['Group Delay for ', filter_name]);
    xlabel('Normalized Angular Frequency (\pi rad/s)');
    ylabel('Group Delay (samples)');
    grid on;

    % 4. Impulse Response
    figure('Name', [filter_name ': Impulse Response']);
    impz(b, a);
    title(['Impulse Response for ', filter_name]);
    grid on;
    
    % Check if the input is available
    if ~isempty(x_n) && (numel(x_n) > 1)
        % MSE
        y = filter(b, a, x_n);  % Apply filter to signal
        mse = sum((y - x_n).^2)/(length(x_n)+1);
        fprintf('MSE (Filtered vs Original): %.3e\n', mse);

        % Energy Loss
        energy_y = sum(abs(y).^2);
        energy_loss = energy_x - energy_y;
        energy_loss = (energy_loss / energy_x) * 100;
        fprintf('Energy Loss: %.2f %%\n', energy_loss);
    else
        fprintf('Skipping MSE and Energy Loss calculation (No input signal provided).\n');
    end
end
