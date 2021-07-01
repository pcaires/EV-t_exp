D = dlmread('EV_2021.04A', ';', 1,0);
t = D(:,1);                                             % Time (s)
L = length(t);
Ts = t(2)-t(1);                                         % Sampling Interval (sec)
Fs = 1/Ts;                                              % Sampling Frequency (Hz)
Fn = Fs/2;                                              % Nyquist Frequency (Hz)

for i = [2:5]
  a =  D(:,i);
  figure()
  plot(t,a)
  xlabel('Tempo (s)')
  ylabel('Accel (m^2/s)')
  FTa = fft(a)/L;                                         % Fourier Transform (Scaled)
  Fv = linspace(0, 1, fix(L/2)+1)*Fn;                     % Frequency Vector
  Iv = 1:length(Fv);                                      % Index Vector
  figure()
  plot(Fv, abs(FTa(Iv))*2)                                % One-Sided Amplitude Plot
  xlabel('Frequency (Hz)')
  xlim([0 25])
  ylabel('Amplitude (g)')
  grid
end