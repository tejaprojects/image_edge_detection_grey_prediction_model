function [target,nmod,str]=redo(inputMat,i,j,n,pixel,arr)
    nmod=n+1;
    sizeArr=size(arr);
    sizeIn=size(inputMat);
    if ((i-((0.5*((sizeArr(1,1))+1))-1))==1)...
            ||((j-((0.5*((sizeArr(1,2))+1))-1))==1)...
            ||((i+((0.5*((sizeArr(1,1))+1))-1))==(sizeIn(1,1)))...
            ||((j+((0.5*((sizeArr(1,2))+1))-1))==(sizeIn(1,2)))
        target=pixel;
        str='pixel';
    else
        target=takeArr(nmod,inputMat,i,j);
        str='arr';
    end
return
