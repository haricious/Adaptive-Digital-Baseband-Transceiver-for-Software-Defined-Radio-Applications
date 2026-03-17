function M = cognitive_engine(estimated_snr)
    % cognitive_engine: Selects modulation based on channel conditions
    % Inputs:
    %   estimated_snr - The Signal to Noise Ratio estimated by the receiver (dB)
    % Outputs:
    %   M - The chosen modulation order (2, 4, 16, or 64)
    
    % Threshold-based hysteresis logic to maximize spectral efficiency
    % while keeping BER below the target threshold.
    
    if estimated_snr < 6
        M = 2;      % Deep fade / heavy noise -> BPSK (Robust)
    elseif estimated_snr >= 6 && estimated_snr < 12
        M = 4;      % Moderate channel -> QPSK
    elseif estimated_snr >= 12 && estimated_snr < 18
        M = 16;     % Good channel -> 16-QAM
    else
        M = 64;     % Excellent channel -> 64-QAM (High Throughput)
    end
end