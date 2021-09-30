function [InterInd, NumVar] = IntersectRank(ind1,ind2)
n1=length(ind1);
n2=length(ind2);
k=1;
for i=1:n1
    for j=1:n2
       %% InterInd: Intersection lndice
       InterInd{k,1}=intersect(ind1{i},ind2{j});
       %% NumVar: The number of elements in the intersection
        NumVar(k,1)=length(InterInd{k,1});
        k=k+1;
    end       
end
ind=find(~NumVar);
InterInd(ind,:)=[];
NumVar(ind,:)=[];

