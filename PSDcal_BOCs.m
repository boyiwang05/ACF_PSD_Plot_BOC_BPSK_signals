%%%%%%%%%%%%%%%%%%%%%%%%% BOCs  �����׼��� %%%%%%%%%%%%%%%%%%%%
function PSD_BOCs  = PSDcal_BOCs(f, fs, Tc)
% f : Hz
% fs: Hz
% Tc: S

MM1 = 2*fs*Tc;
T_BOC = Tc;
f(find(f==0))=eps;        
if (MM1/2)>floor(MM1/2)+0.2   %�жϵ���ָ�� MM=2*n/m �Ƿ�������
    PSD_BOCs =  (sin(pi*f*T_BOC/MM1).*cos(pi*f*T_BOC)./(pi*f.*cos(pi*f*T_BOC/MM1))).^2/T_BOC;
    index= (abs(cos(pi*f*T_BOC/MM1))<1e-6);
    PSD_BOCs(index)= (MM1^2)*(sin(pi*f(index)*T_BOC)).^2/T_BOC./((pi*f(index)).^2);%Ϊ�˽��Matlab�������⣬�Գ�������С�ĵ㣬�������ޱȴ﷨��(��������С�������=���ǵĵ����ı�)
else
    PSD_BOCs =  (sin(pi*f*T_BOC/MM1).*sin(pi*f*T_BOC)./(pi*f.*cos(pi*f*T_BOC/MM1))).^2/T_BOC;
    index= (abs(cos(pi*f*T_BOC/MM1))<1e-6);
    PSD_BOCs(index)= (MM1^2)*(cos(pi*f(index)*T_BOC)).^2/T_BOC./((pi*f(index)).^2);
end
