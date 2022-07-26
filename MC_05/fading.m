%% Rayleigh fading

fs = 2000; % sample rate
fd = 100; % MaximumDoppler Shift %80Hz for car, 4Hz for pedstrain

rayChan = comm.RayleighChannel('SampleRate', fs, 'MaximumDopplerShift', fd);

ricianChan = comm.RicianChannel('SampleRate', fs, 'MaximumDopplerShift', fd);

sig = 1i*ones(2000, 1); % Signal
out = rayChan(sig); % Pass signal through channel.

rayChan % Display all properties of the channel object
ricianChan
figure
plot(20*log10(abs(out)))

figure
plot(20*log(abs(ricianChan(sig))))
