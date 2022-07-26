clc        %for clearing the command window
close all  %for closing all the window except command window
clear all  %for deleting all the variables from the memory

nPSK=2;    %QPSK
nSymbol=100000;%Number of Input Symbol
nbit=nSymbol*nPSK;%Number of Input Bit
Eb=1;      %Energy Bit
itr=20;    %Number of Itration
BER=1:itr; %Bit Error Rate
%Bit Error Rate Calculation
for SNRdb=1:1:itr   % SNR in dB
    counter=0;  
    SNR=10.^(SNRdb/10);
    No=1/SNR;
    v=(No/Eb)/(2*nPSK);   % Noise Equation
for n=1:1:nSymbol
    u1=rand(1);      %random  first bit generation 
    u2=rand(1);      %random second bit generation
    
    u1=round(u1);    %round first bit to(1 or 0)
    u2=round(u2);    %round second bit to(1 or 0)
    
    %Modulation Process
    if(u1==0 && u2==0)
        real=cosd(0);
        img=sind(0);
 
    elseif(u1==0 && u2==1)
        real=cosd(90);
        img=sind(90);
        
       
     elseif(u1==1 && u2==0)
        real=cosd(180);
        img=sind(180);
            
     elseif(u1==1 && u2==1)
        real=cosd(270);
        img=sind(270);
 
    end
    
   %Transmition Process
    AWGN1=sqrt(v)*randn(1);
    AWGN2=sqrt(v)*randn(1);
    
   %Channel
    realn=real+AWGN1;          
    imgn=img+AWGN2;
    
   %RX
   phin=mod(atan2d(imgn,realn)+360,360);
   
   if((phin>=0&&phin<=45)||(phin>315))
        uu1=0;
        uu2=0;
    elseif(phin>45&&phin<=135)
        uu1=0;
        uu2=1;
    elseif(phin>135&&phin<=225)
        uu1=1;
        uu2=0; 
    elseif(phin>225&&phin<=315)
        uu1=1;
        uu2=1;            
    end
    %Detection Process
    if(u1~=uu1)          %logic according to 8PSK
        counter=counter+1;
    end
    if(u2~=uu2)          %logic according to 8PSK
        counter=counter+1;
    end
end
BER(SNRdb)=(counter/nbit);  %Calculate error/bit
end
SNRdb=1:1:itr;
pe=0.5*erfc(sqrt(10.^(SNRdb/10))); %Theoretical Bit Error Rate
figure('name','BER_QPSK','numbertitle','off');
semilogy(SNRdb,BER,'--g*','linewidth',1.5,'markersize',8);
axis([1 itr 10^(-4) 1]);
title(' curve for Bit Error Rate Vs SNRdb for QPSK modulation');
xlabel(' SNRdb(dB)');
ylabel('BER');
grid on;
hold on;
%Plot Bit Error Rate
semilogy(SNRdb,pe,'--bs','linewidth',1.5,'markersize',6);
axis([1 itr 10^(-4) 1]);
xlabel('SNRdb(dB)');
ylabel('BER');
grid on;
hold on;
legend('simulation','theoretical');