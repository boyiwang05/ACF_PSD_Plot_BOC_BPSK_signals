% BOCc  �����׼��� %%%%%%%%%%%%%%%%%%%%
function PSD_BOCc  = PSDcal_BOCc(f, fs, Tc)
%BOC������Ƭ�Ĺ������ܶ�
% f : Hz
% fs: Hz�����ز�Ƶ�ʣ�Ts=1/(2fs)�����ز�������������
% Tc: S����Ƭ����
%Rc=1/Tc,��Ƭ����

MM1 = 2*fs*Tc;
T_BOC = Tc;
f(find(f==0))=eps;        
if (MM1/2)>floor(MM1/2)+0.2   %�жϵ���ָ�� MM=2*n/m �Ƿ�������
    PSD_BOCc =  ((cos(pi*f*T_BOC).*(cos(pi*f*T_BOC/MM1)-1))./(pi*f.*cos(pi*f*T_BOC/MM1))).^2/T_BOC;
    index= (abs(cos(pi*f*T_BOC/MM1))<1e-6);
    PSD_BOCc(index)= (MM1^2).*(cos(pi*f(index)*T_BOC/MM1)-1).^2.*(sin(pi*f(index)*T_BOC)).^2/T_BOC./((pi*f(index)).^2)./(sin(pi*f(index)*T_BOC/MM1)).^2;
else
    PSD_BOCc =  ((sin(pi*f*T_BOC).*(cos(pi*f*T_BOC/MM1)-1))./(pi.*f.*cos(pi.*f*T_BOC/MM1))).^2/T_BOC;
    index= (abs(cos(pi*f*T_BOC/MM1))<1e-6);
    PSD_BOCc(index)=(MM1^2).*(cos(pi*f(index)*T_BOC/MM1)-1).^2.*(cos(pi*f(index)*T_BOC)).^2/T_BOC./((pi*f(index)).^2)./(sin(pi*f(index)*T_BOC/MM1)).^2;
end