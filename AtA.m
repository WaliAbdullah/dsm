
load file_col.mat;

%A= [   1,1,0,0,0,0,0;  1,0,1,0,0,0,0;  0,1,1,0,0,0,0; 0,0,1,1,0,0,0; 0,0,0,1,1,0,0; 0,0,0,1,0,1,0; 0,0,0,1,0,0,1; 0,0,0,0,1,1,0; 0,0,0,0,1,0,1; 0,0,0,0,0,1,1 ]
%save file_col.mat A
I=eye(columns(A))
T=A'

B= (T*A)-I
