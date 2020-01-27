load input_sparse.mat; 
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
Expected_Cluster=D(E,E);
%Z=D*Y;
%Expected_Cluster=Y*Z
%status = odswrite ('output.ods', Expected_Cluster,'expected');

%Bus threshold related coding
busTHRESHOLD=100; % we assume bus threshold is 10 percent. It can vary.

printf("Bus Threshold = %d %%\n",busTHRESHOLD);
i=1;
while(i<=N)  
    temp=nnz(D(:,i));
    bus=temp/N*100;
    if(bus>busTHRESHOLD) 
        printf("%d = %d\n",i,temp);
        D(i,:)=[]; % deleting row
        D(:,i)=[]; % deleting column
        N=N-1;
        i--;
    endif
    i++;
endwhile
N
%Bus threshold ends here


%Initialization%
totalCost=0;
costMatrix = zeros(N,N);
thisCost=0.0;
lambda =2;    % we assume this value according to the paper

cluster = eye(N); % element i is in cluster i. i.e. cluster[i][i]=1
numCluster=N; % number of cluster = nRows of cluster = N
whichCluster = (1:N); % whichCluster[i] returns the cluster that contains i
whichCluster =whichCluster';  % converted from row vec to col vec
 
% To track number of clusters & deleting an empty cluster
numCluster=N;
i=1;
while(i!=numCluster)
  if(nnz(cluster(i,:))==0) 
    for j=1:N
      if(whichCluster(j,1)>=i)
        whichCluster(j,1)=whichCluster(j,1)-1;
      endif
    endfor
    numCluster--;
    cluster(i,:)=[];
  endif
  i++;
endwhile
% numCluster & deleting empty cluster ends here


for i=1:N     % N=input.size
  for j=i+1:N
      size= N; % if i, j are in differnt cluster then size =N (input sze) 
      if(whichCluster(i,1)==whichCluster(j,1)) 
         size=nnz(cluster(whichCluster(i,1),:)); %otherwise, size = cluster size
      endif  
      %printf("\nSize=%d",size);
      thisCost= (D(i,j)+D(j,i))* (size^lambda);
      costMatrix(i,j) = thisCost;
      costMatrix(j,i) = thisCost;
      totalCost += thisCost;
  endfor
endfor
%costMatrix
%printf("\nTotal Cost=%d\n",totalCost);
%Initialization ends here


% Main clustering process
noUpdate=0; % to track stability of the reduction
stable=false;
while(!stable)  % cluster until there is no improvement possible
  sourceElement=randi(N);    % pick a random element
  % source Cluster is the cluster where the randomly picked vertex stays 
  sourceCluster=whichCluster(sourceElement,1);    
  bestBid=0;
  bestCluster=0;
  THRESHOLD=0;  % we can vary this value for selecting bestBid
  
  for i=1:numCluster  % i is now the destination cluster
    if(i!=sourceCluster)
      %calculating cost reduction
      result=0;
      n=nnz(cluster(i,:))+1;    % size of destination cluster
      m=nnz(cluster(sourceCluster,:));    % size of source cluster
      
      % In to Out in source cluster
      factor=(0-(m^lambda)+(N^lambda));
      % list will contain the elements of the source cluster 
      list=find(cluster(sourceCluster,:),N); 
      for x=1:m
        y=list(1,x); % y \in list (picking one by one)
        result+=D(y,sourceElement) * factor;
        result+=D(sourceElement,y) * factor;
      endfor
      %out to in
      factor=(0-(N^lambda)+(n^lambda));
      % list will contain the elements of the destination cluster i
      list=find(cluster(i,:),N);
      for x=1:n-1
        y=list(1,x);  % y \in list (picking one by one)
        result+=D(sourceElement,y) * factor;
        result+=D(y,sourceElement) * factor;
      endfor
      
      % source cluster dependencies
      factor=(0-(m^lambda)+((m-1)^lambda));
      % list will contain the elements of the source cluster 
      list=find(cluster(sourceCluster,:),N);
      for x=list
        for y=list
          if(x!=y&&x!=sourceElement&&y!=sourceElement)
            result+=D(x,y)*factor;
          endif
        endfor
      endfor
      
      %dest cluster dependencies
      factor=(0-((n-1)^lambda)+(n^lambda));
      list=find(cluster(i,:),N);
      for x=list
        for y=list
          if(x!=y)
            result+=D(x,y)*factor;
          endif
        endfor
      endfor
      
      costReduction=result;
      %%%%%%%%%%%%%%%%%%%%%%
      if(costReduction < bestBid)
        bestBid=costReduction;
        bestCluster=i;
      endif
    endif
  endfor
  if(bestBid < THRESHOLD)
    totalCost += bestBid;
    % adding the sourceElement into the bestCluster 
    cluster(bestCluster,sourceElement)=1;
    whichCluster(sourceElement,1)=bestCluster; % update the cluster number of
                                               % sourceElement
    % removing the sourceElement from the sourceCluster
    cluster(sourceCluster,sourceElement)=0;
    if(nnz(cluster(sourceCluster,:))==0) 
      for j=1:N
        if(whichCluster(j,1)>=sourceCluster)
          whichCluster(j,1)=whichCluster(j,1)-1;
        endif
      endfor
      numCluster--;
      cluster(sourceCluster,:)=[];
    endif
    noUpdate=0;
  else
    noUpdate++;
  endif
  % no more improvement to cluster cost
  if(noUpdate==50)
    stable=true;  % for checking purpose. delete later
  endif
endwhile
printf("Total Cost=%d\n",totalCost);
printf("Number of Cluster=%d\n",numCluster);
%cluster

new_list = (1:N);
k=1;
for i=1:numCluster
    printf("Cluster[%d]= ",i);
    for j=1:N
        if (cluster(i,j)==1)
            printf("%d, ",j);
            new_list(k)=j;
            k++;        
        endif
    endfor
    printf("\n");
endfor

% rearranging Matrix D according to our cluster
%V=eye(N);
%for i=1:N
%    V(i,i)=0;
%    V(i,new_list(i))=1;
%endfor
%new_list;
%V;
%D;
%W=D*V;
Result= D(new_list,new_list);

status = odswrite ('output.ods', Result,'result');
