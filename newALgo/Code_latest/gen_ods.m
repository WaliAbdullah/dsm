load input_D.mat; 
load expected_output.mat; 

N=columns(D);
M=rows(D);

if(N!=M) 
  msg='Error in the Input Matrix';
  error(msg);
endif

% Showing a matrix by rearranging D w.r.t. expected cluster from the book.
%Y=eye(N);
%for i=1:N
%    Y(i,i)=0;
%    Y(i,E(i))=1;
%endfor
Expected_Cluster=D(E,E)
%Z=D*Y;
%Expected_Cluster=Y*Z
status = odswrite ('output.ods', Expected_Cluster,'expected');
