%%Initialization
clear variables
clc

%% Parameters
SNR_dB = -10 : 1 : 20;
SNR_linear = 10.^(SNR_dB/10);
SER = zeros(1, length(SNR_dB));


for i = 1 : 1: length(SNR_dB)
    %% Prepration (DATA)

    nSymbol = 100000;
    
    BPSK_modulated_symbol = zeros(1, nSymbol);
    QPSK_modulated_symbol = zeros(1, nSymbol);


    M = 2;
        % 2: BPSK, 4: QPSK, 8: 8-PSK

        BPSK_data = randi([0, 1], 1, nSymbol);
        QPSK_data = randi([0, 3], 1, nSymbol);
        %%Modulation (BPSK)

    
        if M == 2
            BPSK_modulated_symbol(BPSK_data == 1) = (1+1i)/sqrt(2);
            BPSK_modulated_symbol(BPSK_data == 0) = (-1-1i)/sqrt(2);
        end

    Q = 4;
        if Q == 4
            QPSK_modulated_symbol(QPSK_data == 0) = (1+1i)/sqrt(2);
            QPSK_modulated_symbol(QPSK_data == 1) = (-1+1i)/sqrt(2);
            QPSK_modulated_symbol(QPSK_data == 2) = (-1-1i)/sqrt(2);
            QPSK_modulated_symbol(QPSK_data == 3) = (+1-1i)/sqrt(2);
          
        end
        %% Transmission Systems

        transmit_power = SNR_linear(i);
        BPSK_transmission_symbol = sqrt(transmit_power)*BPSK_modulated_symbol;
        QPSK_transmission_symbol = sqrt(transmit_power)*QPSK_modulated_symbol;

        AWGN = sqrt(1/2)*(rand(1, nSymbol) + 1j*randn(1, nSymbol));

        %% Receiver - Demoduation (BPSK)

        BPSK_received_symbol = BPSK_transmission_symbol + AWGN;
        QPSK_received_symbol = QPSK_transmission_symbol + AWGN;

        BPSK_recovered_data = zeros(1, nSymbol);
        QPSK_recovered_data = zeros(1, nSymbol);

        if M == 2
            BPSK_recovered_data((real(BPSK_received_symbol) + imag(BPSK_received_symbol)) > 0) = 1;
            BPSK_recovered_data((real(BPSK_received_symbol) + imag(BPSK_received_symbol)) < 0) = 0;
        end

        if Q == 4
            QPSK_recovered_data(0 <= real(QPSK_received_symbol) & 0 < imag(QPSK_received_symbol)) = 0;
            QPSK_recovered_data(0 > real(QPSK_received_symbol) & 0 <= imag(QPSK_received_symbol)) = 1;
            QPSK_recovered_data(0 > real(QPSK_received_symbol) & 0 > imag(QPSK_received_symbol)) = 2;
            QPSK_recovered_data(0 <= real(QPSK_received_symbol) & 0 > imag(QPSK_received_symbol)) = 3;

        end

    %% Sum

    BPSK_SER(i) = sum(BPSK_data ~= BPSK_recovered_data) / nSymbol;
    QPSK_SER(i) = sum(QPSK_data ~= QPSK_recovered_data) / nSymbol;
    QPSK_BER(i) = sum(QPSK_data ~= QPSK_recovered_data) / nSymbol * 8;
    

end

%% Ploting SER Curve Plotting
figure(1);
semilogy(SNR_dB, BPSK_SER, 'bo');
hold on
semilogy(SNR_dB, QPSK_SER, 'r+');
ylim([10^-5 1]); xlim([-10 20]);
ylabel('SER'); xlabel('SNR(DB)');
title('BPSK SER vs QPSK SER');
legend('BPSK', 'QPSK');

%% Ploting BER Curve Plotting
figure(2);
semilogy(SNR_dB, QPSK_BER, 'g+');
ylabel('BER'); xlabel('Eb/N0(dB)');
title('QPSK BER');
legend('QPSK');


%% QPSK Constellation

%% Parameters
SNR_dB = 0;
SNR_linear = 10.^(SNR_dB/10);
SER = zeros(1, length(SNR_dB));


for i = 1 : 1: length(SNR_dB)
    %% Prepration (DATA)

    nSymbol = 100;
    
    QPSK_modulated_symbol = zeros(1, nSymbol);

    QPSK_data = randi([0, 3], 1, nSymbol);
    %%Modulation (BPSK)

    Q = 4; % 2: BPSK, 4: QPSK, 8: 8-PSK
        if Q == 4
            QPSK_modulated_symbol(QPSK_data == 0) = (1+1i)/sqrt(2);
            QPSK_modulated_symbol(QPSK_data == 1) = (-1+1i)/sqrt(2);
            QPSK_modulated_symbol(QPSK_data == 2) = (-1-1i)/sqrt(2);
            QPSK_modulated_symbol(QPSK_data == 3) = (+1-1i)/sqrt(2);
          
        end
        %% Transmission Systems

        transmit_power = SNR_linear(i);
        QPSK_transmission_symbol = sqrt(transmit_power)*QPSK_modulated_symbol;

        AWGN = sqrt(1/2)*(rand(1, nSymbol) + 1j*randn(1, nSymbol));
        
        %% Receiver - Demoduation (BPSK)

        QPSK_received_symbol = QPSK_transmission_symbol + AWGN;


end

figure(3);
plot(real(QPSK_received_symbol), imag(QPSK_received_symbol), 'b*');
grid on;
hold on
%% Parameters
SNR_dB = 10;
SNR_linear = 10.^(SNR_dB/10);
SER = zeros(1, length(SNR_dB));


for i = 1 : 1: length(SNR_dB)
    %% Prepration (DATA)

    nSymbol = 100;
    
    QPSK_modulated_symbol = zeros(1, nSymbol);

    QPSK_data = randi([0, 3], 1, nSymbol);
    %%Modulation (BPSK)

    Q = 4; % 2: BPSK, 4: QPSK, 8: 8-PSK
        if Q == 4
            QPSK_modulated_symbol(QPSK_data == 0) = (1+1i)/sqrt(2);
            QPSK_modulated_symbol(QPSK_data == 1) = (-1+1i)/sqrt(2);
            QPSK_modulated_symbol(QPSK_data == 2) = (-1-1i)/sqrt(2);
            QPSK_modulated_symbol(QPSK_data == 3) = (+1-1i)/sqrt(2);
          
        end
        %% Transmission Systems

        transmit_power = SNR_linear(i);
        QPSK_transmission_symbol = sqrt(transmit_power)*QPSK_modulated_symbol;

        AWGN = sqrt(1/2)*(rand(1, nSymbol) + 1j*randn(1, nSymbol));
        
        %% Receiver - Demoduation (BPSK)

        QPSK_received_symbol = QPSK_transmission_symbol + AWGN;

end
plot(real(QPSK_received_symbol), imag(QPSK_received_symbol), 'g*');
title('QPSK Constellation');
legend('0dB', '10dB');
