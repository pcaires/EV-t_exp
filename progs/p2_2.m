pkg load signal
clear all
clc


D = dlmread('images/p2/extremos_az.txt', ';', 1,0);
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
  inv = N2>N1;
  for i = 1:length(t)
    b1 = a_z(i) > N1;
    if xor(inv,b1) && !init   # iniciar contagem
      init = 1;
    end
    if init # incrementar contagem
      b2 = a_z(i) < N2;
      if xor(inv,b2)
        init = 0;
        c(j) = c(j) + 1;
      end
    end
  end
end

fid = fopen("images/p2/ciclos_az.txt","wt");
fprintf(fid,"Numero de ciclos para pares de N1 e N2\n\n");
for i = 1:length(c)
  fprintf(fid,"N1:%2.1f; N2:%2.1f; ciclos:%d\n",N(1,i),N(2,i),c(i));
end
fclose(fid);
