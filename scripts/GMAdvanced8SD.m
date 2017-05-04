function target=GMAdvanced8SD(x)
    x0=x';
    x0=x0(:)';

    % 0-AGO
    n=8;
    X0=[x0(2),x0(4),x0(6),x0(8),x0(1),x0(3),x0(7),x0(9)];

    Stand_Dev=std(X0);
    if (Stand_Dev>=0)&&(Stand_Dev<0.01)
        p=2;
    else
        if (Stand_Dev>=0.01)&&(Stand_Dev<0.1)
            p=3;
        else
            if (Stand_Dev>=0.1)&&(Stand_Dev<127.5)
                p=4;
            end
        end
    end

    % 1-AGO
    X1=[];
    for k=1:1:n
        x1(k)=0;
        for i=1:1:k
            x1(k)=x1(k)+X0(i);
        end
        X1=[X1 x1(k)];
    end

    B=[];
    for k=2:1:n
        z1(k)=0.5*(x1(k)+x1(k-1));
        B=[B;(-1)*z1(k) 1];
    end
    BT=B';

    yn=[X0(2:n)]';

    U=((inv(BT*B))*BT)*yn;
    a=U(1);
    b=U(2);

    % Time response sequence : xh1
    for k=0:1:n
        xh1(k+1)=(X0(1)-(b/(a*p)))*exp((-1)*a*p*k)+(b/(a*p));
    end

    % Inverse Augmentation
    xh0(1)=xh1(1);
    for k=1:1:n
        xh0(k+1)=xh1(k+1)-xh1(k);
    end

    % Target-pixel value
    target=xh0(9);
return
