%% 

clear variables
clc

%%

% rng = 10;

%% Parameters

%SNR_dB = -10:1:20;
 SNR_dB = 20;

SNR_linear = 10.^(SNR_dB/10); % Signal Power
SER = zeros(1, length(SNR_dB));

nSymbol = 1;
M= 4; % 2: BPSK, 4: QPSK / QAM, 8:8- PSK, 16: 16QAM

for i = 1: 1: length(SNR_dB)

    %% Preparation(DATA)
    %data = randi([0, M-1], 1, nSymbol); % 0 1 0 1 2 3 1 2 3
     data = zeros(1, nSymbol);

    %% Transmitter - Modulation
    modulated_symbol = zeros(1, nSymbol);

    if M == 2
        modulated_symbol(data == 1 ) = 1;
        modulated_symbol(data == 0 ) = -1;

    elseif M == 4

        [A, B, C, D] = CMO_function(4);

        for k = 1: 1: length(data)
            switch data(k)
                case A
                    modulated_symbol(k) = 1 + 1j;
                case B
                    modulated_symbol(k) = -1 + 1j;
                case C
                    modulated_symbol(k) = -1 - 1j;
                case D
                    modulated_symbol(k) = 1 - 1j;
            end
        end
    end

    modulated_symbol = modulated_symbol / sqrt(2);


    figure(1);
    plot(real(modulated_symbol), imag(modulated_symbol), 'b*'); grid on;
    xlim([-10 10]); ylim([-10 10]);
    xlabel('In-Phase'); ylabel('Quadrature');

    %% Transmission Systems
    transmit_power = SNR_linear(i); % Signal Strength
    transmission_symbol = sqrt(transmit_power)*modulated_symbol;

    AWGN = sqrt(1/2)*(randn(1, nSymbol) + 1j*randn(1, nSymbol)); 
    % X ~ N(0, 1), AX ~ N(0, 1*A^2)


    %% Receiver - Demodulation
    received_symbol = transmission_symbol + AWGN;

    figure(1);
    hold on;
    plot(real(received_symbol), imag(received_symbol), 'ro');

    recovered_data = zeros(1, nSymbol);

    if M == 2
        recovered_data((real(received_symbol) + imag(received_symbol)) > 0) = 1;
        recovered_data((real(received_symbol) + imag(received_symbol)) < 0) = 0;

    elseif M == 4
       % recovered_data(real(received_symbol) > 0 & imag(received_symbol) > 0) = 0;
       % recovered_data(real(received_symbol) > 0 & imag(received_symbol) < 0) = 3;
       % recovered_data(real(received_symbol) < 0 & imag(received_symbol) > 0) = 1;
       % recovered_data(real(received_symbol) < 0 & imag(received_symbol) < 0) = 2;


        [A, B, C, D] = CMO_function(5);
        recovered_data(real(received_symbol) > 0 & imag(received_symbol) > 0) = A;
        recovered_data(real(received_symbol) > 0 & imag(received_symbol) < 0) = D;
        recovered_data(real(received_symbol) < 0 & imag(received_symbol) > 0) = B;
        recovered_data(real(received_symbol) < 0 & imag(received_symbol) < 0) = C;

    end

    % SER = Symbol Error Rate
    SER(i) = sum(data ~= recovered_data) / nSymbol;

end


%% Theory - SER(Symbole Error Rate)

figure (100);
if M == 2
    P_ser = 2*(M-1)/M*qfunc(sqrt(6*SNR_linear/(M^2-1)));
    semilogy(SNR_dB, P_ser, 'b-'); hold on;
elseif M == 4 % QAM
    P_ser = 4*(1-1/sqrt(M))*qfunc(sqrt(3*SNR_linear/(M-1))) - 4*((1-1/sqrt(M))*qfunc(sqrt(3*SNR_linear/(M-1)))).^2;
    semilogy(SNR_dB, P_ser, 'b-'); hold on;
end

%% Plotting SER Curve
semilogy(SNR_dB, SER, 'bo'); grid on;

ylim([10^-5 1]); xlim([-10 20]);
ylabel('SER'); xlabel('SNR(dB');
