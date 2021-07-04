pkg load signal
clear all
clc


D = dlmread('EV_2021.04B', ';', 1,0);
t = D(:,1);                                             % Time (s)

g = 9.80665;

yname = {'EAS (kts)','QNE (ft)','Accel. Z (m/s^2)','N2 (%)',...
         'Fuel Flow (lb/h)','Exhaust Gas Temperature (K)'}
         
fn = {'EAS','QNE','a_z','N2','FF','EGT'}



for i = [2:4]
  y =  D(:,i);
  hf = figure()
  plot(t,y,'linewidth',2)
  xlabel('Tempo (s)')
  ylabel(yname{i-1})
  grid
  print(hf,['resultados/p2/' fn{i-1} '.svg'])
  close
end
for i = [5:7]
  y1 =  D(:,i);
  y2 =  D(:,i+3);
  hf = figure()
  plot(t,y1,'linewidth',2,...
       t,y2,'linewidth',2)
  xlabel('Tempo (s)')
  ylabel(yname{i-1})
  legend('Direita','Esquerda')
  grid
  print(hf,['resultados/p2/' fn{i-1} '.svg'])
  close
end

a_g = D(:,4)/g;
##plot(t,a_g)
##a_g_filter = sgolayfilt(a_g,3,7)

[px1 idx1] = findpeaks(a_g,'DoubleSided');
##[val idx2] = findpeaks(-a_g)


plot(t,a_g,'linewidth',2,...
     t(idx1),px1,'o','MarkerSize',10)

fid = fopen("resultados/p2/extremos_az.txt","wt");
fprintf(fid,"t; a_z \n");
for i = 1:length(idx1)
  fprintf(fid,"%f; %f \n",t(idx1(i)),px1(i));
##  print("%f; %f \n",t(idx1(i)),px1(i))
end
fclose(fid)





