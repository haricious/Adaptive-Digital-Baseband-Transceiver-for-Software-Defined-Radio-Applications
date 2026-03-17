function [rx_sig, h] = channel_model(tx_sig, snr_db)
    % channel_model: Simulates Fading and AWGN
    
    % 1. Flat Rayleigh Fading Model
    % Generates a single-tap complex Gaussian channel coefficient
    h = (randn(1) + 1i*randn(1)) / sqrt(2);
    faded_sig = tx_sig .* h;
    
    % 2. Additive White Gaussian Noise (AWGN)
    rx_sig = awgn(faded_sig, snr_db, 'measured');
end