load input_D.mat;      %This line will read DSM matrix into D for CSPARSE
%load adolc_D.mat;       %This line will read DSM matrix into D for ADOL-C

threshhold=0.3;
N=columns(D);
M=rows(D);

if(N!=M) 
  msg='Error in the Input Matrix';
  error(msg);
endif

%S = sparse(A);
%spy(S)

elements=(1:N);

%[V,lambda] = eig(A);
%B=diag(lambda);
%plot (elements, B);
while(N>0)
    % find hub rank
    B = transpose(D);
    Ch =  D * B; %hub
    [V,lambda] = eig(Ch);
    v_high=V(:,N);
    v_high=abs(v_high); % to get the result as MSc paper remove this line. This line is correct and included during writing the paper
    [_,hu]=sort(v_high);
    hu=flipud(hu);

    % find authority rank
    B = transpose(D);
    Ca =  B * D;  %authority
    [V,lambda] = eig(Ca);
    v_high=V(:,N);
    v_high=abs(v_high); % to get the result as MSc paper remove this line. This line is correct and included during writing the paper
    [_,au]=sort(v_high);
    au=flipud(au);

    % control the length of elements to be considered
    if(N>5)size=5;
    else   size=N;
    endif

    hu=hu(1:size); % taking first size elements from hub
    au=au(1:size); % taking first size elements from authority
    
    hu=transpose(hu); % converting to row vector
    au=transpose(au); % converting to row vector
    
    val_hu = (1:size);
    val_au = (1:size);
    for i=1:size
        val_hu(i)=0;
        val_au(i)=0;        
    endfor

    % hub calculation
    for i=1:(size-1)
        for j=i+1:size
            x=hu(i);
            y=hu(j);
            %u= Ch(x,:);
            %v= Ch(y,:);
            u= D(x,:);
            v= D(y,:);
            normU=norm(u);
            normV=norm(v);
            if( normU!=0 && normV!=0 ) 
                cosTheta= dot(u,v)/( normU * normV );
            else cosTheta= 0;
            endif            
            val_hu(i)=val_hu(i)+cosTheta;
            val_hu(j)=val_hu(j)+cosTheta;
        endfor
    endfor

%    zero_hu=0; % to check the zero vector
    for i=1:size
        if(size>1) 
            val_hu(i)=val_hu(i)/(size-1);
%            zero_hu=zero_hu+val_hu(i);
        endif
    endfor    

    % authority calculation
    for i=1:(size-1)
        for j=i+1:size
            x=au(i);
            y=au(j);
            %u= Ca(:,x);
            %v= Ca(:,y);
            u= D(:,x);
            v= D(:,y);

            normU=norm(u);
            normV=norm(v);
            if( normU!=0 && normV!=0 ) 
                cosTheta= dot(u,v)/( normU * normV );
            else cosTheta= 0;
            endif            
            val_au(i)=val_au(i)+cosTheta;
            val_au(j)=val_au(j)+cosTheta;
        endfor
    endfor

%    zero_au=0; % to check the zero vector
    for i=1:size
        if(size>1) 
            val_au(i)=val_au(i)/(size-1);
%            zero_au=zero_au+val_au(i);
        endif
    endfor 


    DelList=[]; % will track the elements to delete later
    DelSize=0;

    hub_continue=0;
    printf("\nHub Cluster: ");
    for i=1:size
%        if(zero_hu < threshhold) break; % no further calculation if already found zero vectors
%        endif
        if(val_hu(i)>=threshhold)
            hub_continue=1;
            x=hu(i);
            elements(x);
            printf("%d ",elements(x));
            DelSize=DelSize+1;    
            DelList(DelSize)=x;    
        endif
    endfor
    printf("\n");

    authority_continue=0;
    printf("\nAuthority Cluster: ");
    for i=1:size
%        if(zero_au < threshhold) break; % no further calculation if already found zero vectors
%        endif
        if(val_au(i)>=threshhold)
            authority_continue=1;
            x=au(i);
            elements(x);
            printf("%d ",elements(x));
            DelSize=DelSize+1;    
            DelList(DelSize)=x;    
        endif
    endfor
    printf("\n");

%    if(zero_au < threshhold &&zero_hu < threshhold) break; % stop all calculation if hub and authority both give zero vectors
%    endif
    if(authority_continue==0 && hub_continue==0) break; % stop all calculation if hub and authority both give zero vectors
    endif

    % DelList contain all the deleting elements from hub and authority.
    % We have to delete all of them by descending order. Thus we memorized them in the same list
    DelList=unique(DelList); % delete List may contain duplicate elements coming from hub and authorities. remove those.
    [DelList,_]=sort(DelList);
    DelList=fliplr(DelList); % deleting the elements in descending order helps to track all elements' real identity

    for x=DelList
        D(x,:)=[]; % deleting row
        D(:,x)=[]; % deleting column
        elements(x)=[];
    endfor
    N=columns(D);
endwhile
