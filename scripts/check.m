function outputMat=check(arr,inputMat,outputMat,i,j,n)
    med=median(arr(:));
    sizeArr=size(arr);
    pixel=arr(((sizeArr(1))+1)/2,((sizeArr(2))+1)/2);
    if (min(min(arr))<med)&&(med<max(max(arr)))
        if (min(min(arr))<pixel)&&(pixel<max(max(arr)))
            outputMat=pixel;
        else
            outputMat=med;
        end
    else
        [received,nmod,str]=redo(inputMat,i,j,n,pixel,arr);
        if strcmp(str,'pixel')==1
            outputMat=received;
        else
            arr=received;
            outputMat=check(arr,inputMat,outputMat,i,j,nmod);
        end
    end
return
