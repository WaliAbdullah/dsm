load result_participated_node.mat; 
N=columns(E);
E=sort(E);
%for i=1:N
%    Y(i,i)=0;
%    Y(i,E(i))=1;
%endfor
N
E

j=1;
for i=1:64
    if(j<=N && i==E(j))
        j++;
    else   printf(" %d",i);
    endif
endfor
