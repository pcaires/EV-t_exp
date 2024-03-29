pkg load mapping
clear all
clc

spath = 'images/p3/'              %Save path 
ftype = '.tex'                    %File type 

D = dlmread('EV_2021.04C', ';', 1,0);
t_s = D(:,1);               % tempo da semana (s)
%t_w = D(:,2);              % numero da semana

HPL =  D(:,11);
VPL =  D(:,12);

NS_LAT = D(:,5);
NS_LON = D(:,6);
NS_ALT = D(:,7);

REF_LAT = D(:,13);
REF_LON = D(:,14);
REF_ALT = D(:,15);

el = wgs84Ellipsoid('meter');

[NSx,NSy,NSz] = geodetic2ecef(el,NS_LAT,NS_LON,NS_ALT);

[REFx,REFy,REFz] = geodetic2ecef(el,REF_LAT,REF_LON,REF_ALT);

[E_NOR,E_EAS,E_DOWN] = geodetic2ned(NS_LAT,NS_LON,NS_ALT,...
                                    REF_LAT,REF_LON,REF_ALT,el);
                                    
Ex = NSx - REFx;
Ey = NSy - REFy;
Ez = NSz - REFz;


clc

VPE = NS_ALT - REF_ALT;

for i = 1:length(t_s)
  %Erro total
  E(i) = norm([Ex(i) Ey(i) Ez(i)]);
  
  %HPE superficie da elipsoide wgs84
  HPE1(i) = norm([E_NOR(i) E_EAS(i)]);
  
  %HPE plano perpendicular altitude aeronave
  HPE2(i) = sqrt(E(i)^2 - VPE(i)^2);
  
end


n = {'Latitude','Longitude','Altitude'}
n2 = {' ($\degree$)',' ($\degree$)', ' (m)'}

for i = 1:3     %lat lon alt
  hf = figure();           
  plot(t_s,D(:,4+i),'linewidth',2)
  xlabel('Tempo (s)')
  ylabel([n{i} n2{i}])
  grid
  print(hf,[spath n{i} ftype])
  close
end

hf = figure();  %PE       
plot(t_s,E);
xlabel('Tempo (s)')
ylabel('Erro de Pos. (m)')
grid
print(hf,[spath 'erro' ftype]);
close


hf = figure();            %erro eixo horizontal Norte
plot(t_s,E_NOR,'linewidth',2)
xlabel('Tempo (s)')
ylabel('Erro NORTE(m)')
grid
print(hf,[spath 'err_hor_norte' ftype])
close

hf = figure();            %erro eixo horizontal Este
plot(t_s,E_EAS,'linewidth',2)
xlabel('Tempo (s)')
ylabel('Erro ESTE(m)')
grid
print(hf,[spath 'err_hor_este' ftype])
close

hf = figure();            %erro eixo vertical
plot(t_s,E_DOWN,'linewidth',2)
xlabel('Tempo (s)')
ylabel('Erro vertical (m)')
grid
print(hf,[spath 'err_ver' ftype])
close

hf = figure();            %Numero de satelites
plot(t_s,D(:,3),'linewidth',2,...
     t_s,D(:,4),'linewidth',2)
xlabel('Tempo (s)')
ylim([6 13])
ylabel('Sat. usados')
legend('NSV\_LOCK','NSV\_USED')
grid
print(hf,[spath 'nsv_used' ftype])
close

pVPE95 = prctile(VPE,95);
pHPE95_1 = prctile(HPE1,95);
pHPE95_2 = prctile(HPE2,95);

pVPL99 = prctile(VPL,99);
pHPL99 = prctile(HPL,99);

fid = fopen([spath "percentis.txt"],"wt");
fprintf(fid,"Percentis 95 para limites ICAO\n");
fprintf(fid,"VPE: %f; HPE (elips): %f; HPE (aero): %f \n\n",pVPE95,pHPE95_1,pHPE95_2);
fprintf(fid,"Percentis 99 para limites ICAO\n");
fprintf(fid,"VPL: %f; HPL : %f \n",pVPL99,pHPL99);
fclose(fid);


hf = figure();            %HPE 1
plot(t_s,HPE1,'linewidth',2,...
     [115500 119500],[pHPE95_1 pHPE95_1],'--','linewidth',1,...
     [115500 119500],[16 16],'linewidth',1)
xlabel('Tempo (s)')
ylabel('HPE (m)')
legend('HPE','HPE (95\%)','\small{Lim. APV-I/II, CAT-I}')
grid
print(hf,[spath 'HPE1' ftype])
close

hf = figure();            %HPE 2
plot(t_s,HPE2,'linewidth',2,...
     [115500 119500],[pHPE95_2 pHPE95_2],'--','linewidth',1,...
     [115500 119500],[16 16],'linewidth',1)
xlabel('Tempo (s)')
ylabel('HPE (m)')
legend('HPE','HPE (95\%)','\small{Lim. APV-I/II, CAT-I}')
grid
print(hf,[spath 'HPE2' ftype])
close

hf = figure();            %HPE2 - HPE1
plot(t_s,HPE2-HPE1,'linewidth',2)
xlabel('Tempo (s)')
ylabel('HPE2 - HPE1 (m)')
ylim([-1e-6 5e-6])
grid
print(hf,[spath 'HPE_diff' ftype])
close


hf = figure();            %VPE
plot(t_s,VPE,'linewidth',2,...
     [115500 119500],[pVPE95 pVPE95],'--','linewidth',1,...
     [115500 119500],[20 20],'linewidth',1,...
     [115500 119500],[8 8],'linewidth',1,...
     [115500 119500],[5 5],'linewidth',1)
xlabel('Tempo (s)')
ylabel('VPE (m)')
ylim([-5 22])
legend('VPE','VPE (95\%)','Lim. APV-I','Lim. APV-II', '\small{Lim. CAT-I}')
grid
print(hf,[spath 'VPE' ftype])
close

hf = figure();            %HPL
plot(t_s,HPL,'linewidth',2,...
     [115500 119500],[pHPL99 pHPL99],'--','linewidth',1,...
     [115500 119500],[40 40],'linewidth',1)
xlabel('Tempo (s)')
ylabel('HPL (m)')
legend('HPL','HPL (99\%)','\small{Lim. HAL APV-I/II, CAT-I}')
ylim([5 42])
grid
print(hf,[spath 'HPL' ftype])
close

hf = figure();            %HPE e HPL
plot(t_s,HPE1,'linewidth',2,...
     t_s,HPL,'linewidth',2)
     
[m,i] = max(HPE1);
text(t_s(i)+100,m-1,['max(HPE) = ' num2str(m) 'm']);
text(t_s(i)+100,HPL(i)+2,['RX\_TOM = ' num2str(t_s(i)) 's ;HPL = ' num2str(HPL(i)) 'm']);

xlabel('Tempo (s)')
ylabel('HPE e HPL (m)')
legend('HPE','HPL')
grid
print(hf,[spath 'HPE_HPL' ftype])
close

hf = figure();            %VPL
plot(t_s,VPL,'linewidth',2,...
     [115500 119500],[pVPL99 pVPL99],'--','linewidth',1,...
     [115500 119500],[50 50],'linewidth',1,...
     [115500 119500],[20 20],'linewidth',1,...
     [115500 119500],[12 12],'linewidth',1)
xlabel('Tempo (s)')
ylabel('VPL (m)')
legend('VPL','VPL (99\%)','Lim. VAL APV-I','Lim. VAL APV-II', '\small{Lim. VAL CAT-I}')
ylim([5 52])
grid
print(hf,[spath 'VPL' ftype])
close


hf = figure();            %VPE e VPL
plot(t_s,VPE,'linewidth',2,...
     t_s,VPL,'linewidth',2)

xlabel('Tempo (s)')
ylabel('VPE e VPL (m)')
legend('VPE','VPL')
grid
print(hf,[spath 'VPE_VPL' ftype])
close
