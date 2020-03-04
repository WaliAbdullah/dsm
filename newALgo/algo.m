load input_D.mat;      %This line will read DSM matrix into D
load input_HUB.mat
load input_AUTHORITY.mat

N=columns(D);
M=rows(D);

if(N!=M) 
  msg='Error in the Input Matrix';
  error(msg);
endif

A=D(HUB,HUB);
%A=D(AUT,AUT);

Temp=HUB;
    B = transpose(A);
    C = A * B;

%Temp=AUT;
%    B = transpose(A);
%    C = B * A;

dec = .05
threshhold=.7;
while(N>=5)
    if(threshhold>.2) threshhold=threshhold-dec;
    endif

    val = (1:5);
    for i=1:5
        val(i)=0;
    endfor

    for i=1:4
        for j=i+1:5
            u= C(i,:);
            v= C(j,:);
            x=norm(u);
            y=norm(v);
        
            if(x!=0 && y!=0) cosTheta= dot(u,v)/(norm(u)*norm(v));
            else cosTheta=0;
            endif

            val(i)=val(i)+cosTheta;
            val(j)=val(j)+cosTheta;
        endfor
    endfor

    for i=1:5
        val(i)=val(i)/4;
    endfor

    for i=5:-1:1
        if(val(i)>=threshhold)
            printf("%d ",Temp(i));
            C(i,:)=[]; % deleting row
            C(:,i)=[]; % deleting column
            Temp(i)=[];
            N=N-1;
        endif
    endfor
    printf("\n");
    if(val(1)<threshhold && val(2)<threshhold && val(3)<threshhold && val(4)<threshhold && val(5)<threshhold) break;
    endif
endwhile
%while(N>1)
%    val = (1:N);
%    for i=1:N
%        val(i)=0;
%    endfor

%    for i=1:(N-1)
%        for j=i+1:N
%            u= C(:,i);
%            v= C(:,j);
%            cosTheta= dot(u,v)/(norm(u)*norm(v));
%            val(i)=val(i)+cosTheta;
%            val(j)=val(j)+cosTheta;
%        endfor
%    endfor

%    for i=1:N
%        val(i)=val(i)/(N-1);
%    endfor

%    for i=N:-1:1
%        if(val(i)>=threshhold)
%            printf("%d ",Temp(i));
%            C(i,:)=[]; % deleting row
%            C(:,i)=[]; % deleting column
%            Temp(i)=[];
%            N=N-1;
%        endif
%    endfor
%    printf("\n");
%endwhile
%if(N>0) printf("%d\n",Temp(1));
%endif
