function x_zero=zero_cross(x,y)
%计算过零点时，横坐标的值
L=length(x);
x_zero=0;
for k=1:L-1
    x_temp1=x(k);
    x_temp2=x(k+1);
    y_temp1=y(k);
    y_temp2=y(k+1);
    if y_temp2==0
        x_zeros=x_temp2;
    end
    if y_temp1*y_temp2<0
        x_zero=x_temp1-y_temp1*(x_temp2-x_temp1)/(y_temp2-y_temp1);
    end
end