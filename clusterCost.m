load myfile.mat;
N=columns(D);
M=rows(D);
if(N!=M) 
  msg='Size problem in the Input Matrix';
  error(msg)
endif
I=eye(N);
sum=I;
mul=D;
while(nnz(mul)!=0)
  sum=sum+mul;
  mul=mul*D;
endwhile

printf("RESULT\n*************\n");
V=sum
cost=0;
for i=1:N
  temp=nnz(sum(i,:));
  cost=cost+temp;
  printf("FanOut of %c is %d\n",64+i, temp);
endfor
printf("*************\n");
for i=1:N
  printf("FanIn of %c is %d\n",64+i, nnz(sum(:,i)));
endfor
cost=round(cost/(6*6)*100);
printf("Propagation Cost is %d%%\n",cost);