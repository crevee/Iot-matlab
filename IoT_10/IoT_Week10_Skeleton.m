%% 

clear variables
clc

%%

N = [1:1:9, 10:10:40]; % 전체 단말의 수
n = 10; % 스케줄링된 단말의 수
W = 100*10^6; % 100MHz

%%
nlter = 10000;
result = zeros(length(N), length(n));

for NLoop = 1: 1: length(N)
    for nLoop = 1 : 1: length(n)
        B = W/min(N(NLoop), n(nLoop));

        for iTer = 1: 1: nlter
            SNRdB = 30*rand(1, N(NLoop)) - 10;
            SNRlinear = 10.^(SNRdB/10);

       %[~, index] = sort(SNRdB, 'descend');
       %scheduledIndex = index(1:min(N(NLoop), n(nLoop)));

         scheduledIndex = randperm(N(NLoop), min(N(NLoop), n(nLoop)));

        C = B * log2(1+ SNRlinear(scheduledIndex));
        sumrate = sum(C)/10^6;

        result(NLoop, nLoop) = result(NLoop, nLoop) + sumrate;
        end
    end
end

result = result/nlter;

fprintf('Average sumrate : %f (Mbps) \n', result);

figure(101);
plot(N, result); hold on;
%plot(n, result); hold on;

%%
xlabel('Number of IoT devices');
%xlabel('Number of scheduled IoT devices');
ylabel('Average sum rate (Mbps)');
legend('Max C/I', 'Round robin');