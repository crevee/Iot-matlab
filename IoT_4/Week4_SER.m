clear variables
clc

%% Parameters
SNR_dB = -10:1:20;
SNR_linear = 10.^(SNR_dB/10); % Signal Power / Noise Power
SER = zeros(1, length(SNR_dB));


for i = 1 : 1 : length(SNR_dB)
    %%Prepration (DATA)
    
    nSymbol = 100000;
    
    M = 2; % 2: BPSK, 4: QPSK, 8: 8-PSK, 16:16QAM
    
    data = randi([0, M-1], 1, nSymbol);
    
    
    %% Modulation (BPSK)
        
    % 0 -> -cos(2pifct) / s2(left) -> -1
    % 1 -> cos(2pifct) / s1(right) -> 1
    
    modulated_symbol = zeros(1, nSymbol);
    
    if M == 2
        % modulated_symbole(data == 1) = 1;
        % modulated_symbole(data == 0) = -1;
    
        modulated_symbol(data == 1) = (1+1j)/sqrt(2);
        modulated_symbol(data == 0) = (-1-1j)/sqrt(2);
    
    elseif M == 4
    
    end
    
    %figure(1);
    %plot(real(modulated_symbol), imag(modulated_symbol), 'b*'); grid on;
    %xlim([-5 5]); ylim([-5 5]);
    %xlabel('In-Phase'); ylabel('Quadrature');
    
    
    %% Transmission Systems
    
    transmit_power = SNR_linear(i); %Signal Strength
    transmission_symbol = sqrt(transmit_power)*modulated_symbol;
    AWGN = sqrt(1/2)*(rand(1, nSymbol) + 1j*randn(1, nSymbol)); % X~N(0,1), AX ~ N(0, 1*A^2)
    % transmission_symbol = transmission_symbol + AWGN; % I^2R, V^2/r, VI == P
    
    
    %% Receiver - Demodulation (BPSK)
    
    %received_symbol = modulated_symbol;
    received_symbol = transmission_symbol + AWGN;
    
    %figure(1);
    %hold on; % reset prevent
    %plot(real(received_symbol), imag(received_symbol), 'ro');
    
    recovered_data = zeros(1, nSymbol);
    
    if M == 2
        recovered_data((real(received_symbol) + ...
        imag(received_symbol)) > 0) = 1;
        recovered_data((real(received_symbol) + ...
        imag(received_symbol)) < 0) = 0;
    
    elseif M == 4
    
    end
    
    
    %%
    % SER == Symbol Error Rate
    SER(i) = sum(data ~= recovered_data) / nSymbol;
end


%%Ploting SER Curve
figure(100);
semilogy(SNR_dB, SER, 'bo');
ylim([10^-5 1]); xlim([-10 20]);
ylabel('SER'); xlabel('SNR(DB)');