function S=CA_code(prn)
N=1023;
S=zeros(1,N);
G1=ones(1,10);
G2=ones(1,10);
for i=1:N
    switch prn
        case 1
            S(i)=mod((G1(10)+G2(2)+G2(6)),2);
        case 2
            S(i)=mod((G1(10)+G2(3)+G2(7)),2);
        case 3
            S(i)=mod((G1(10)+G2(4)+G2(8)),2);
        case 4
            S(i)=mod((G1(10)+G2(5)+G2(9)),2);
        case 5
            S(i)=mod((G1(10)+G2(1)+G2(9)),2);
        case 6
            S(i)=mod((G1(10)+G2(2)+G2(10)),2);
        case 7
            S(i)=mod((G1(10)+G2(1)+G2(8)),2);
        case 8
            S(i)=mod((G1(10)+G2(2)+G2(9)),2);
        case 9
            S(i)=mod((G1(10)+G2(3)+G2(10)),2);
        case 10
            S(i)=mod((G1(10)+G2(2)+G2(3)),2);
        case 11
            S(i)=mod((G1(10)+G2(3)+G2(4)),2);
        case 12
            S(i)=mod((G1(10)+G2(5)+G2(6)),2);
        case 13
            S(i)=mod((G1(10)+G2(6)+G2(7)),2);
        case 14
            S(i)=mod((G1(10)+G2(7)+G2(8)),2);
        case 15
            S(i)=mod((G1(10)+G2(8)+G2(9)),2);
        case 16
            S(i)=mod((G1(10)+G2(9)+G2(10)),2);
        case 17
            S(i)=mod((G1(10)+G2(1)+G2(4)),2);
        case 18
            S(i)=mod((G1(10)+G2(2)+G2(5)),2);
        case 19
            S(i)=mod((G1(10)+G2(3)+G2(6)),2);
        case 20
            S(i)=mod((G1(10)+G2(4)+G2(7)),2);
        case 21
            S(i)=mod((G1(10)+G2(5)+G2(8)),2);
        case 22
            S(i)=mod((G1(10)+G2(6)+G2(9)),2);
        case 23
            S(i)=mod((G1(10)+G2(1)+G2(3)),2);
        case 24
            S(i)=mod((G1(10)+G2(4)+G2(6)),2);
    end
     
    temp1=G1;
    G1(2:10)=G1(1:9);
    G1(1)=mod((temp1(3)+temp1(10)),2);
    temp2=G2;
    G2(2:10)=G2(1:9);
    G2(1)=mod((temp2(2)+temp2(3)+temp2(6)+temp2(8)+temp2(9)+temp2(10)),2);
end
for i=1:N
    if S(i)==0
        S(i)=1;
    else
        S(i)=-1;
    end
end