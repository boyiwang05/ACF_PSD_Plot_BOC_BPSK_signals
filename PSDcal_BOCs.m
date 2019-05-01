%%%%%%%%%%%%%%%%%%%%%%%%% BOCs  功率谱计算 %%%%%%%%%%%%%%%%%%%%
function PSD_BOCs  = PSDcal_BOCs(f, fs, Tc)
% f : Hz
% fs: Hz
% Tc: S

MM1 = 2*fs*Tc;
T_BOC = Tc;
f(find(f==0))=eps;        
if (MM1/2)>floor(MM1/2)+0.2   %判断调制指数 MM=2*n/m 是否是奇数
    PSD_BOCs =  (sin(pi*f*T_BOC/MM1).*cos(pi*f*T_BOC)./(pi*f.*cos(pi*f*T_BOC/MM1))).^2/T_BOC;
    index= (abs(cos(pi*f*T_BOC/MM1))<1e-6);
    PSD_BOCs(index)= (MM1^2)*(sin(pi*f(index)*T_BOC)).^2/T_BOC./((pi*f(index)).^2);%为了解决Matlab精度问题，对出现无穷小的点，采用了罗比达法则(两个无穷小的数相比=它们的导数的比)
else
    PSD_BOCs =  (sin(pi*f*T_BOC/MM1).*sin(pi*f*T_BOC)./(pi*f.*cos(pi*f*T_BOC/MM1))).^2/T_BOC;
    index= (abs(cos(pi*f*T_BOC/MM1))<1e-6);
    PSD_BOCs(index)= (MM1^2)*(cos(pi*f(index)*T_BOC)).^2/T_BOC./((pi*f(index)).^2);
end
