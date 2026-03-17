clear; close all; clc;

fprintf('Initializing PACT Architecture Simulation...\n');

% --- 1. Global System Parameters ---
params.numBits = 24000;         % Bits per transmission frame
params.sps = 4;                 % Samples per symbol
params.span = 10;               % RRC Filter span in symbols
params.rolloff = 0.35;          % RRC Filter roll-off factor
params.snrRange = 0:2:24;       % SNR range in dB to test
params.targetBER = 1e-3;        % Target Quality of Service

% Initialize storage arrays
ber_adaptive = zeros(size(params.snrRange));
ber_fixed    = zeros(size(params.snrRange));
mod_history  = zeros(size(params.snrRange));

% Create the RRC Filter Object once to save compute time
params.rrcFilter = rcosdesign(params.rolloff, params.span, params.sps, 'sqrt');

% --- 2. Main Simulation Loop ---
for idx = 1:length(params.snrRange)
    current_snr = params.snrRange(idx);
    fprintf('Simulating SNR = %d dB...\n', current_snr);
    
    %% ADAPTIVE SYSTEM SIMULATION
    % A. Cognitive Engine (Feedback Loop)
    % In a real system, this is based on the previous frame's RX estimation.
    % Here, we use the current channel SNR to represent perfect CSI feedback.
    M_adaptive = cognitive_engine(current_snr);
    mod_history(idx) = M_adaptive;
    
    % B. Transmitter
    [tx_sig_adapt, tx_bits_adapt] = tx_baseband(M_adaptive, params);
    
    % C. Channel
    [rx_sig_adapt, chan_gain_adapt] = channel_model(tx_sig_adapt, current_snr);
    
    % D. Receiver
    rx_bits_adapt = rx_baseband(rx_sig_adapt, chan_gain_adapt, M_adaptive, params);
    
    % E. Error Calculation
    [~, ber_adaptive(idx)] = biterr(tx_bits_adapt, rx_bits_adapt);
    
    %% FIXED SYSTEM SIMULATION (For Comparison in Chapter 8)
    M_fixed = 4; % Compare against a static QPSK system
    [tx_sig_fix, tx_bits_fix] = tx_baseband(M_fixed, params);
    [rx_sig_fix, chan_gain_fix] = channel_model(tx_sig_fix, current_snr);
    rx_bits_fix = rx_baseband(rx_sig_fix, chan_gain_fix, M_fixed, params);
    [~, ber_fixed(idx)] = biterr(tx_bits_fix, rx_bits_fix);
end

fprintf('\nSimulation Complete! Generating plots...\n');

% --- 3. Plotting Results ---
% We will pass the data to our dedicated plotting function
plot_metrics(params.snrRange, ber_adaptive, ber_fixed, mod_history);