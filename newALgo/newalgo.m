load input_D.mat;      %This line will read DSM matrix into D

N=columns(D);
M=rows(D);

if(N!=M) 
  msg='Error in the Input Matrix';
  error(msg);
endif

attempt=0;
SIZE=5;
threshhold=.4
while(N>=5)

    B = transpose(D);
    C =  D * B;
%   C =  B * D;
    [V,lambda] = eig(C);
    v_high=V(:,N);
    [_,I]=sort(v_high);
    I=flipud(I);
    D=D(I,I);

%    if(N<5) 
%        SIZE=N;
%    endif
    Temp=I;
    val = (1:SIZE);
    for i=1:SIZE
        val(i)=0;
    endfor

    for i=1:(SIZE-1)
        for j=i+1:SIZE
            u= D(i,:);
            v= D(j,:);

%            u= D(:,i);
%            v= D(:,j);

            normU=norm(u);
            normV=norm(v);
           if( normU!=0 && normV!=0 ) 
                cosTheta= dot(u,v)/( normU * normV );
            else cosTheta= 0;
           endif            
            val(i)=val(i)+cosTheta;
            val(j)=val(j)+cosTheta;


        endfor
    endfor

    for i=1:SIZE
        val(i)=val(i)/(SIZE-1);
    endfor

    for i=SIZE:-1:1
        if(val(i)>=threshhold)
            printf("%d ",Temp(i));
            D(i,:)=[]; % deleting row
            D(:,i)=[]; % deleting column
            Temp(i)=[];
            N=N-1;
        endif
    endfor
    printf("\n");
%    if(attempt==1&&N!=0)
%        for i=N:-1:1
%            printf("%d ",Temp(i));
%            D(i,:)=[]; % deleting row
%            D(:,i)=[]; % deleting column
%            Temp(i)=[];
%        endfor
%        N=0;
%    endif

    if(val(1)<threshhold&&val(2)<threshhold&&val(3)<threshhold&&val(4)<threshhold&&val(5)<threshhold) break;
    endif
endwhile
