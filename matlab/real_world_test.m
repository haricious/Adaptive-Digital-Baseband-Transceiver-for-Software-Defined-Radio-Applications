%% PROJECT 5: VECTOR IMAGE TRANSMISSION TEST (BIKE.PNG)
clear; clc;

% --- 1. Load Vector Data ---
img = imread('bike.png'); 

% Ensure it's treated as a binary image (Black/White)
if size(img, 3) == 3
    img_gray = im2gray(img);
else
    img_gray = img;
end
bw_img = imbinarize(img_gray); % Convert to logical 1s and 0s

% Convert vector image to bitstream
tx_bits = double(bw_img(:)); 

% --- 2. System Setup (PACT Architecture) ---
params.tx_bits = tx_bits;
params.sps = 4;
params.span = 10;
params.rolloff = 0.35;
params.rrcFilter = rcosdesign(params.rolloff, params.span, params.sps, 'sqrt');

% Test Scenario: High-Speed 64-QAM Test
test_snr = 28; 

% --- 3. Run Adaptive Transmission ---
M_adapt = cognitive_engine(test_snr);
fprintf('Adaptive Engine Mode: %d-QAM\n', M_adapt);

[tx_sig, tx_bits_padded] = tx_baseband(M_adapt, params); 
[rx_sig, h]  = channel_model(tx_sig, test_snr);
rx_bits = rx_baseband(rx_sig, h, M_adapt, params);

% --- 4. Reconstruct Vector Image ---
% Remove padding and reshape to original dimensions
rx_bits_clean = rx_bits(1:length(tx_bits));
rx_img = reshape(rx_bits_clean, size(bw_img));

% --- 5. Performance Metrics (Chapter 8) ---
ber = sum(tx_bits ~= rx_bits_clean) / length(tx_bits);
fprintf('Achieved BER: %e\n', ber);

% --- 6. Display Results (High Contrast Light Mode) ---
fig = figure('Name', 'Vector Data Validation', 'Units', 'normalized', 'Position', [0.2, 0.3, 0.6, 0.4]);
set(fig, 'Color', 'w'); % Set figure background to white

% Original Image
subplot(1,2,1); 
imshow(bw_img, 'InitialMagnification', 'fit'); 
title('Original Vector (bike.png)', 'Color', 'k', 'FontSize', 12, 'FontWeight', 'bold');
set(gca, 'Color', 'w'); % Set axis background to white

% Received Image
subplot(1,2,2); 
imshow(rx_img, 'InitialMagnification', 'fit'); 
title(['Received @ ', num2str(test_snr), 'dB (', num2str(M_adapt), '-QAM)'], ...
      'Color', 'k', 'FontSize', 12, 'FontWeight', 'bold');
xlabel(['BER: ', num2str(ber, '%.2e')], 'Color', 'k'); % Optional: Display BER under plot
set(gca, 'Color', 'w'); % Set axis background to white

% Global font adjustments for clarity
set(findall(fig,'-property','FontName'),'FontName','Arial');