clear all
clc

spath = 'images/p3/'              %Save path 
ftype = '.tex'                    %File type 

D = dlmread('EV_2021.04C', ';', 1,0);

t_s = D(:,1);               % tempo da semana (s)
VPL =  D(:,12);

NS_LAT = D(:,5);
NS_LON = D(:,6);

clear D;

T = length(t_s); %Tempo total (intervalo t_s = 1s) 

%Pelos graficos do programa p3.m sabemos que HPL tem disponibilidade 100%
%e que VPL ultrapassa o VAL de CAT-I momentaneamente 
%portanto contabilizamos so para esse limite, assumindo sempre abaixo dos outros

idx1 = [];
idx2 = [];

for i = 1:length(t_s)
  if VPL(i)>12
    dispn(i) = 1;
    idx1(length(idx1)+1) = i;
  else
    dispn(i) = 0;
    idx2(length(idx2)+1) = i;
  end
end

indisp = sum(dispn);
CATIdisp = (T-indisp)/T *100

fid = fopen([spath "dispn.txt"],"wt");
fprintf(fid,"Disponibilidade\n APV-I: 100%%\n APV-II: 100%%\n");
fprintf(fid,"CAT_I: %f %%",CATIdisp);
fclose(fid);


hf = figure();  %Trajetoria          
plot(NS_LON(idx2),NS_LAT(idx2),'linewidth',2,...
     NS_LON(idx1),NS_LAT(idx1),'linewidth',3);
ylabel('NS\_LAT ($\degree$)')
xlabel('NS\_LON ($\degree$)')
xlim([-9.3 -8.7])
grid
legend('\small{Todos os modos disp.}', 'CAT-I indisp.')
print(hf,[spath 'traj' ftype])
%close
