function ind=LabelSplit(Label,NumClass)
for i=1:NumClass
    ind{i,1}=find(Label==i);
end