function [px1 idx1] = findpeaks2(a_g)
  px1(1) = a_g(1);
  idx1(1) = 1;
  j = 2;
  L = length(a_g);
  for i = 2:L-1
    if !xor(a_g(i) > a_g(i-1) , a_g(i+1) < a_g(i))
      px1(j) = a_g(i);
      idx1(j) = i;
      j = j+1;
    end
  end
  px1(j) = a_g(L);
  idx1(j) = L;
end
