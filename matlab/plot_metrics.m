function plot_metrics(snrRange, ber_adapt, ber_fix, mod_history)
    % plot_metrics: Generates thesis-ready graphs for Chapters 7 & 8
    
    % Figure 1: BER vs SNR Comparison
    figure('Name', 'Chapter 8: Performance Analysis', 'Color', 'w');
    semilogy(snrRange, ber_adapt, '-bo', 'LineWidth', 2, 'MarkerFaceColor', 'b'); 
    hold on;
    semilogy(snrRange, ber_fix, '-r^', 'LineWidth', 2, 'MarkerFaceColor', 'r');
    grid on;
    
    % Formatting for Academic Standard
    xlabel('Signal-to-Noise Ratio (SNR) in dB', 'FontWeight', 'bold');
    ylabel('Bit Error Rate (BER)', 'FontWeight', 'bold');
    legend('Proposed PACT (Adaptive M-QAM)', 'Conventional System (Fixed QPSK)', ...
           'Location', 'southwest');
    title('Fig 8.1: BER Performance Comparison in Rayleigh Fading Channel');
    
    % Figure 2: Cognitive Engine Behavior
    figure('Name', 'Chapter 7: Adaptive Logic', 'Color', 'w');
    stairs(snrRange, mod_history, '-k', 'LineWidth', 2.5);
    grid on;
    
    xlabel('Estimated Channel SNR (dB)', 'FontWeight', 'bold');
    ylabel('Modulation Order (M)', 'FontWeight', 'bold');
    yticks([2 4 16 64]);
    yticklabels({'2 (BPSK)', '4 (QPSK)', '16 (16-QAM)', '64 (64-QAM)'});
    title('Fig 7.1: Real-Time Modulation Switching by Cognitive Engine');
    ylim([0 70]);
end