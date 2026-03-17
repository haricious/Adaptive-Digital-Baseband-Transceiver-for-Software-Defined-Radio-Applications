function [tx_sig, tx_bits_padded] = tx_baseband(M, params)
    % tx_baseband: Professional-grade modulator with auto-padding
    
    % Use tx_bits if provided, otherwise generate random bits for testing
    if isfield(params, 'tx_bits')
        tx_bits = params.tx_bits;
    else
        % Fallback for main_pact_sim logic
        tx_bits = randi([0 1], params.numBits, 1);
    end
    
    k = log2(M); % Bits per symbol
    numBits = length(tx_bits);
    
    % --- Adaptive Padding Logic (Ensures Data Alignment) ---
    remainder = mod(numBits, k);
    if remainder ~= 0
        padding = zeros(k - remainder, 1);
        tx_bits_padded = [tx_bits; padding];
    else
        tx_bits_padded = tx_bits;
    end
    
    % 1. Adaptive Mapping [cite: 34]
    tx_symbols = qammod(tx_bits_padded, M, 'InputType', 'bit', 'UnitAveragePower', true);
    
    % 2. Pulse Shaping Filter (RRC) [cite: 19]
    tx_sig = upfirdn(tx_symbols, params.rrcFilter, params.sps);
end