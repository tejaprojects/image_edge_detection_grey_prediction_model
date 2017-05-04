function outputMat=Adaptive_Median_Filter(inputMat)
    inputMat=padarray(inputMat,[1 1]);
    sizeIn=size(inputMat);
    outputMat=zeros(sizeIn(1,1),sizeIn(1,2));
    for i=2:1:sizeIn(1,1)-1
        for j=2:1:sizeIn(1,2)-1
             n=1;
             arr=takeArr(n,inputMat,i,j);
             outputMat(i,j)=check(arr,inputMat,outputMat,i,j,n);
        end
    end
    outputMat=outputMat(2:sizeIn(1,1)-1,2:sizeIn(1,2)-1);
return
