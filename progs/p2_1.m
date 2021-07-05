pkg load signal
clear all
clc

spath = 'images/p2/'              %Save path 
type = '.tex'                     %File type 


D = dlmread('EV_2021.04B', ';', 1,0);
t = D(:,1);                                             % Time (s)

g = 9.80665;

yname = {'EAS (kts)','QNE (ft)','Accel. Z ($m/s^2$)','N2 (\%)',...
         'Fuel Flow (lb/h)','Exhaust Gas Temperature (K)'};
         
fn = {'EAS','QNE','a_z','N2','FF','EGT'};

comp = {'rh','lt','comp'};


for i = [2:4]
  y =  D(:,i);
  hf = figure();
  plot(t,y,'linewidth',2)
  xlabel('Tempo (s)')
  ylabel(yname{i-1})
  grid
  print(hf,[spath fn{i-1} type])
  close
end

for i = [5:7]
  clear y
  y =  [D(:,i) D(:,i+3)];
  for j = [1:3]
    hf = figure();
    if j != 3
      plot(t,y(:,j),'linewidth',2)
    else
      plot(t,y,'linewidth',2)
    end
    xlabel('Tempo (s)')
    ylabel(yname{i-1})
    if j == 3
      legend('Direita','Esquerda')
    end
    grid
    print(hf,[spath fn{i-1} '_' comp{j} type])
    close
  end
end

FF_tot = D(:,5) + D(:,8); #Total Fuel Flow (right + left)(lb/h)
FF_tot = FF_tot *1/3600;  #Total Fuel Flow (lb/s)
F_tot = [];

for i = 1:length(t)
  F_tot(i) = trapz(t(1:i),FF_tot(1:i)); #Total Fuel Consumption (lb)
end

hf = figure();
plot(t,F_tot,'linewidth',2)
xlabel('Tempo (s)')
ylabel('Fuel Consuption (lb)')
grid
print(hf,[spath 'consumo' type])
close


a_g = D(:,4)/g;
##plot(t,a_g)
##a_g_filter = sgolayfilt(a_g,3,7)

[px1 idx1] = findpeaks(a_g,'DoubleSided');
##[val idx2] = findpeaks(-a_g)


#plot(t,a_g,'linewidth',2,...
#     t(idx1),px1,'o','MarkerSize',10)

fid = fopen([spath 'extremos_az.txt'],'wt');
fprintf(fid,"t; a_z \n");
for i = 1:length(idx1)
  fprintf(fid,"%f; %f \n",t(idx1(i)),px1(i));
##  print("%f; %f \n",t(idx1(i)),px1(i))
end

fclose(fid);





