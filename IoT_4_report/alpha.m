
ebno=logspace(0,1.2,12);
snr=10*log10(ebno);
Pb_psk(1,:)=1/2*erfc(sqrt(ebno)); Ps_psk(1,:)=Pb_psk(1,:);
k=2; M=2^k;
Ps_psk(k,:)=erfc(sqrt(k*ebno)*sin(pi/M));
Pb_psk(k,:)=Ps_psk(k,:)/k;

%% 16-QAM
k=4; M=2^k; %16-QAM을 위한 k,M 재설정
Pm=(1-1/sqrt(M))*erfc(sqrt(3/2/(M-1)*k*ebno));
Ps_qam(k,:)=1-(1-Pm).^2;
Pb_qam(k,:)=Ps_qam(k,:)/k;
semilogy(snr,Ps_qam(4,:),'-.co') %16-QAM:일점쇄선,청록,o표
axis([min(snr) max(snr) 1e-6 1])
xlabel('SNR [dB]'); ylabel('(SER) P(s)')
hold on

%% 8-PSK
k=3; M=2^k; %8-PSK을 위한 k,M 재설정
Pm=(1-1/sqrt(M))*erfc(sqrt(3/2/(M-1)*k*ebno));
Ps_qam(k,:)=1-(1-Pm).^2;
Pb_qam(k,:)=Ps_qam(k,:)/k;
semilogy(snr,Ps_qam(3,:),'-.r') %8-PSK:일점쇄선,빨강
legend('16-QAM', '8psk')
axis([min(snr) max(snr) 1e-6 1])
title('16QAM,8-PSK (AWGN 채널)')
xlabel('SNR [dB]'); ylabel('(SER) P(s)')