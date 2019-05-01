% BOCc  功率谱计算 %%%%%%%%%%%%%%%%%%%%
function PSD_BOCc  = PSDcal_BOCc(f, fs, Tc)
%BOC余弦码片的功率谱密度
% f : Hz
% fs: Hz，副载波频率，Ts=1/(2fs)，副载波方波半周期数
% Tc: S，码片长度
%Rc=1/Tc,码片速率

MM1 = 2*fs*Tc;
T_BOC = Tc;
f(find(f==0))=eps;        
if (MM1/2)>floor(MM1/2)+0.2   %判断调制指数 MM=2*n/m 是否是奇数
    PSD_BOCc =  ((cos(pi*f*T_BOC).*(cos(pi*f*T_BOC/MM1)-1))./(pi*f.*cos(pi*f*T_BOC/MM1))).^2/T_BOC;
    index= (abs(cos(pi*f*T_BOC/MM1))<1e-6);
    PSD_BOCc(index)= (MM1^2).*(cos(pi*f(index)*T_BOC/MM1)-1).^2.*(sin(pi*f(index)*T_BOC)).^2/T_BOC./((pi*f(index)).^2)./(sin(pi*f(index)*T_BOC/MM1)).^2;
else
    PSD_BOCc =  ((sin(pi*f*T_BOC).*(cos(pi*f*T_BOC/MM1)-1))./(pi.*f.*cos(pi.*f*T_BOC/MM1))).^2/T_BOC;
    index= (abs(cos(pi*f*T_BOC/MM1))<1e-6);
    PSD_BOCc(index)=(MM1^2).*(cos(pi*f(index)*T_BOC/MM1)-1).^2.*(cos(pi*f(index)*T_BOC)).^2/T_BOC./((pi*f(index)).^2)./(sin(pi*f(index)*T_BOC/MM1)).^2;
end