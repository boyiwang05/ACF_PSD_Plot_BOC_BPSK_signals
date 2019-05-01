clc;
clear;
close all;
%% ��������
BW=1000*1.023e6;

%% ��ʼ��
c=CA_code(1);%�õ�CA������1
L_CA=length(c);%CA�����г���

m=14;n=2;%BOC(1,1)
Rc=n*1.023e6;%������
Tc=1/Rc;%��Ƭ����
fs=m*1.023e6;

f_sample=2000e6;%����Ƶ��
T_sample=1/f_sample;
Tp=1e-3-T_sample;%��ɻ���ʱ��1ms
N_BW=100000;
f=linspace(-BW/2,BW/2,N_BW);
PSD_BOCs  = PSDcal_BOCs(f, fs, Tc);

N_tao=601;
 tao=linspace(-1.05*Tc,1.05*Tc,N_tao);
 for k=1:N_tao
    corr_BOC=(trapz(f,PSD_BOCs.*exp(1i*2*pi*f*(tao(k)))));
    corrResults_BOC(k) = real(corr_BOC);
end  


%% ������غ���
figure;
plot(tao/Tc,corrResults_BOC,'LineWidth',2);legend('BOC(14,2)');xlabel('Code Delay(Tc)');ylabel('Normalized Auto Correlation Function');grid on;axis([-1.05,1.05,-1,1.05]);saveas(gcf,'ACF_BOC142.fig'); 
