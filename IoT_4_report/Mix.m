ebno=logspace(0,1.2,12);
snr=10*log10(ebno);
Pb_psk(1,:)=1/2*erfc(sqrt(ebno)); Ps_psk(1,:)=Pb_psk(1,:);
k=2; M=2^k;
Ps_psk(k,:)=erfc(sqrt(k*ebno)*sin(pi/M));
Pb_psk(k,:)=Ps_psk(k,:)/k;
subplot(3,2,1)
semilogy(snr,Ps_psk(1,:),'--r*',snr,Ps_psk(2,:),':b+') %BPSK:파선,빨강,별표 QPSK:점선,파랑,+표
legend('BPSK','QPSK') 
axis([min(snr) max(snr) 1e-6 1]) %x축과 y축의 범위 설정
title('M-PSK 변조(AWGN 채널)') %그래프 제목 추가
xlabel('SNR [dB]'); ylabel('(SER) P(s)') %좌표축 옆 축 라벨
subplot(3,2,2)
semilogy(snr,Pb_psk(1,:),'--r*',snr,Pb_psk(2,:),':b+')
legend('BPSK','QPSK')
axis([min(snr) max(snr) 1e-6 1])
title('M-PSK 변조 (AWGN 채널)')
xlabel('SNR [dB]'); ylabel('비트 에러 확률(BER) P(b)') 

k=4; M=2^k; %16-QAM을 위한 k,M 재설정
Pm=(1-1/sqrt(M))*erfc(sqrt(3/2/(M-1)*k*ebno));
Ps_qam(k,:)=1-(1-Pm).^2;
Pb_qam(k,:)=Ps_qam(k,:)/k;
subplot(3,2,3)
semilogy(snr,Ps_qam(4,:),'-.co') %16-QAM:일점쇄선,청록,o표
legend('16-QAM')
axis([min(snr) max(snr) 1e-6 1])
title('16-QAM 변조 (AWGN 채널)')
xlabel('SNR [dB]'); ylabel('(SER) P(s)')

subplot(3,2,4)
semilogy(snr,Pb_qam(4,:),'-.co')
legend('16-QAM')
axis([min(snr) max(snr) 1e-6 1])
title('16-QAM 변조 (AWGN 채널)')
xlabel('SNR [dB]'); ylabel('비트 에러 확률 (BER) P(b)')

l=2; M=2^l; %QPSK를 위한 설정
Ps_psk(l,:)=erfc(sqrt(l*ebno)*sin(pi/M));
Pb_psk(l,:)=Ps_psk(l,:)/l;
subplot(3,2,5)
semilogy(snr,Pb_psk(1,:),'--r*',snr,Pb_psk(2,:),':b+',snr,Pb_qam(4,:),'-.co')
legend('BPSK','QPSK','16-QAM')
axis([min(snr) max(snr) 1e-6 1])
title('BPSK QPSK 16-QAM 비교 (AWGN 채널)')
xlabel('SNR [dB]'); ylabel('비트 에러 확률 (BER) P(b)')