pkg load signal
clear all
clc


D = dlmread('resultados/p2/extremos_az.txt', ';', 1,0);
t = D(:,1);
a_z = D(:,2);
clear D

N = [2.0  3.5  5.0  6.0  7.0  0.0  -1.5  -2.5;      # N1
     1.8  3.3  4.8  5.8  6.8  0.2  -1.3  -2.3]      # N2

init = 0;


for j = 1:length(N(1,:))
  N1 = N(1,j);
  N2 = N(2,j);
  c(j) = 0;
  for i = 1:length(t)
    if abs(a_z(i)-1) > abs(N1-1) && !init   # iniciar contagem
      init = 1;
    end
    if init && abs(a_z(i)-1) < abs(N1-1)    # incrementar contagem
      init = 0;
      c(j) = c(j) + 1;
    end
  end
end


fid = fopen("resultados/p2/ciclos_az.txt","wt");
fprintf(fid,"Numero de ciclos para pares de N1 e N2\n\n");
for i = 1:length(c)
  fprintf(fid,"N1:%2.1f; N2:%2.1f; ciclos:%d\n",N(1,i),N(2,i),c(i));
end
fclose(fid)
