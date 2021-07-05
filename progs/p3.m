pkg load mapping
clear all
clc

spath = 'images/p3/'              %Save path 
type = '.tex'                     %File type 

D = dlmread('EV_2021.04C', ';', 1,0);
t_s = D(:,1);               % tempo da semana (s)
t_w = D(:,2);               % numero da semana

el = wgs84Ellipsoid('meter');

[NSx,NSy,NSz] = geodetic2ecef(el,D(:,5),D(:,6),D(:,7));
[REFx,REFy,REFz] = geodetic2ecef(el,D(:,13),D(:,14),D(:,15));


[E_NOR,E_EAS,E_DOWN] = geodetic2ned(D(:,5),D(:,6),D(:,7),...
                                    D(:,13),D(:,14),D(:,15),el);

NS = [NSx NSy NSz];
REF = [REFx REFy REFz];

clear NSx,NSy,NSz,REFx,REFy,REFz
clc

VPE = NS(:,3)-REF(:,3);

for i = 1:length(t_s)
  %erro posição em m
  err_pos(i,:) = [NS(i,:)-REF(i,:) norm(NS(i,:)-REF(i,:))];
  
  %HPE superficie da elipsoide wgs84
  HPE1(i) = distance(NS(i,1),NS(i,2),REF(i,1),REF(i,2));
  
  %HPE plano perpendicular altitude aeronave
  HPE2 = sqrt(err_pos(i)^2 - VPE(i)^2);
  
end

hf = figure();            %erro plano horizontal
plot(t_s,err_pos(:,1),'linewidth',2,...
     t_s,err_pos(:,2),'linewidth',2)
xlabel('Tempo (s)')
ylabel('Erro posição (m)')
legend('Norte','Este')
grid
print(hf,[spath 'err_hor' type])
close

hf = figure();            %erro eixo vertical
plot(t_s,err_pos(:,3),'linewidth',2)
xlabel('Tempo (s)')
ylabel('Erro posição vertical (m)')
grid
print(hf,[spath 'err_ver' type])
close

hf = figure();            %Numero de satelites
plot(t_s,D(:,4),'linewidth',2)
xlabel('Tempo (s)')
ylim([6 10])
ylabel('Numero de satélites usados')
grid
print(hf,[spath 'nsv_used' type])
close

pVPE95 = prctile(VPE,95);
pHPE95_1 = prctile(HPE1,95);
pHPE95_2 = prctile(HPE2,95);

fid = fopen([spath "percentis.txt"],"wt");
fprintf(fid,"Percentis 95 para confirmação limites ICAO\n\n");

fprintf(fid,"VPE: %f; HPE (elips): %f; HPE (aero): %f \n",pVPE95,pHPE95_1,pHPE95_2);

fclose(fid);
