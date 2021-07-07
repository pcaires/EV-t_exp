pkg load signal
clear all

spath = 'images/p1/'              %Save path 
type = '.tex'                     %File type 
D = dlmread('EV_2021.04A', ';', 1,0);
t = D(:,1);                                        % Time (s)
L = length(t);
Ts = t(2)-t(1);                                    % Sampling Interval (sec)
Fs = 1/Ts;                                         % Sampling Frequency (Hz)
Fn = Fs/2;                                         % Nyquist Frequency (Hz)

for i = [2:5]
  a =  D(:,i);
  hf = figure();
  plot(t,a,'linewidth',2)
  xlabel('Tempo (s)')
  ylabel('Accel ($m/s^2$)')
  grid
  print(hf,[spath 'grafico_a' num2str(i-1) type])
  close
  
  FTa = fft(a)/L;                                   % Fourier Transform (Scaled)
  Fv = linspace(0, 1, fix(L/2)+1)*Fn;               % Frequency Vector
  Iv = 1:length(Fv);                                % Index Vector
  
  clear px
  clear idx
  [px idx] = findpeaks(abs(FTa(Iv))*2,"MinPeakHeight",0.2); % Find peaks
  
  if i == 4 || i == 3
    ln = length(idx)
    px(ln+1) = abs(FTa(Iv))(1)*2
    idx(ln+1) = 1
  end
  
  hf = figure();
  
  plot(Fv, abs(FTa(Iv))*2,'linewidth',2,...
       Fv(idx),px,'o','linewidth',2,'MarkerSize',7); % Single-Sided Amplitude Plot and peaks
  
  clear lb
  for j = 1:length(idx)
    lb{j} = ['f= ' num2str(Fv(idx(j))) 'Hz; A= ' num2str(px(j))];
  end
  
  if i != 5
    text(Fv(idx)+0.7,px,lb)
  else
    x = [(Fv(idx(1:3))+0.7) Fv(idx(4))-4]
    y = [px(1:3)' px(4)+0.25]
    a = text(x,y,lb);
  end
  xlabel('Freq. (Hz)')
  xlim([0 25])
  ylabel('Amplitude')
  grid
  print(hf,[spath 'fourier_a' num2str(i-1) type])
  close
end