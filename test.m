load testfile.mat;
N=columns(D);
m=D;
m=m*D;
m=m*D;
A=diag(m)';
sum=0;
for i=1:N
  sum=sum+A(i);
endfor
triangle = sum/6