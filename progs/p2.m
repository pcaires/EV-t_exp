pkg load signal
clear all
clc


D = dlmread('EV_2021.04B', ';', 1,0);
t = D(:,1);                                             % Time (s)
L = length(t);

g = 9.80665;

label = {'grad1','grad2','grad2','grad2','grad2','grad2','grad2','grad2','grad2'};


##
##for i = [2:10]
##  y =  D(:,i);
##  figure()
##  plot(t,y)
##  xlabel('Tempo (s)')
##  ylabel(label{i-1})
##  grid
##end


a_g = D(:,4)/g;
##plot(t,a_g)
##a_g_filter = sgolayfilt(a_g,3,7)

[px1 idx1] = findpeaks(a_g,'DoubleSided');
##[val idx2] = findpeaks(-a_g)


plot(t,a_g,'linewidth',2,...
     t(idx1),px1,'o','MarkerSize',10)

fid = fopen("extremos_az.txt","wt");
fprintf(fid,"t; a_z \n");
for i = 1:length(idx1)
  fprintf(fid,"%f; %f \n",t(idx1(i)),px1(i));
##  print("%f; %f \n",t(idx1(i)),px1(i))
end
fclose(fid)



