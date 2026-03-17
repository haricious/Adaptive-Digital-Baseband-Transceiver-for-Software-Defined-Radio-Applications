function rx_bits = rx_baseband(rx_sig, h, M, params)
    % rx_baseband: Professional-grade receiver with dynamic bit-length detection
    
    % 1. Matched Filtering
    rx_mf = upfirdn(rx_sig, params.rrcFilter, 1, params.sps);
    
    % 2. Frame Synchronization (Remove Filter Delay)
    delay = params.span;
    rx_sync = rx_mf(delay + 1 : end - delay);
    
    % 3. 1-Tap Zero-Forcing Equalizer
    % Reverses phase shift and attenuation from Rayleigh fading
    rx_eq = rx_sync ./ h;
    
    % --- DYNAMIC LENGTH DETECTION ---
    % Determine total bits (including padding) sent by the transmitter
    if isfield(params, 'tx_bits')
        total_bits = length(params.tx_bits);
    else
        total_bits = params.numBits;
    end
    
    k = log2(M);
    % Ensure num_symbols covers the padded bitstream length
    num_symbols = ceil(total_bits / k);
    
    % Trim to the exact symbol count
    rx_eq = rx_eq(1:num_symbols);
    
    % 4. Adaptive Demapping
    rx_bits = qamdemod(rx_eq, M, 'OutputType', 'bit', 'UnitAveragePower', true);
end