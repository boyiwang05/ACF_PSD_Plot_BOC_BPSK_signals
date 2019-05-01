%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%���մ���36*1.023MHz
%���ߣ�������
%����������0.01Tc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear;
close all;
%% ��������
BW=14*1.023e6;

Power_BPSK = 1/3;
Power_BOC11 = 20/33;
Power_BOC61 = 2/33;

%% ��ʼ��
c=CA_code(1);%�õ�CA������1
L_CA=length(c);%CA�����г���

m_11=1;n_11=1;%BOC(1,1)
Rc_11=n_11*1.023e6;%������
Tc_11=1/Rc_11;%��Ƭ����
fs_11=m_11*1.023e6;

m_61=6;n_61=1;%BOC(6,1)
Rc_61=n_61*1.023e6;%������
Tc_61=Tc_11;%��Ƭ����
fs_61=m_61*1.023e6;

n_BPSK=1;%BPSK(1)
Rc_BPSK=n_BPSK*1.023e6;%������
Tc_BPSK=1/Rc_BPSK;%��Ƭ����

f_sample=100e6;%����Ƶ��
T_sample=1/f_sample;
Tp=1e-3-T_sample;%��ɻ���ʱ��1ms

N_BW=100000;
f=linspace(-BW/2,BW/2,N_BW);

%% ���·������
%BOC��1,1��������
PSD_BOCs_11  = PSDcal_BOCs(f, fs_11, Tc_11);

%BOC��6,1��������
PSD_BOCs_61  = PSDcal_BOCs(f, fs_61, Tc_61);

%BPSK�Ĺ�һ�������׹�����
PSD_R  = PSDcal_R(f, Tc_BPSK);

%��һ�������׹�����
PSD_BPSK1_norm = PSD_R/trapz(f,PSD_R);
PSD_BOCs_11_norm  = PSD_BOCs_11/trapz(f,PSD_BOCs_11);
PSD_BOCs_61_norm  = PSD_BOCs_61/trapz(f,PSD_BOCs_61);

%MBOC�Ĺ�һ�������׹�����
PSD_MBOC_norm = 10/11*PSD_BOCs_11_norm + 1/10*PSD_BOCs_61_norm;

%Hybrid_BOC�Ĺ�һ�������׹�����
PSD_Hybrid_BOC_norm = Power_BPSK*PSD_BPSK1_norm+Power_BOC11*PSD_BOCs_11_norm+Power_BOC61*PSD_BOCs_61_norm;
% PSD_Hybrid_BOC_norm = PSD_Hybrid_BOC/trapz(f,PSD_Hybrid_BOC);

figure;
plot(f/1e6,10*log10(PSD_MBOC_norm),f/1e6,10*log10(PSD_Hybrid_BOC_norm));
axis([f(1)/1e6,f(end)/1e6,-100,-60]);
grid on;
xlabel('Ƶ��[MHz]');
ylabel('��һ��������[dB/Hz]');
legend('MBOC(6,1,1/11)','Hybrid BOC');

%% ������غ����ͼ�������
N_tao=601;
tao=linspace(-1.5*Tc_11,1.5*Tc_11,N_tao);
C=1;
d = 0.05*Tc_11;%��������

for k=1:N_tao
    %MBOC
    corr_MBOC=(trapz(f,PSD_MBOC_norm.*exp(1i*2*pi*f*(tao(k)))));
    corrResults_MBOC(k) = real(corr_MBOC);

    corrL_MBOC=real(trapz(f,PSD_MBOC_norm.*exp(1i*2*pi*f*(tao(k)+d/2))));
    corrE_MBOC=real(trapz(f,PSD_MBOC_norm.*exp(1i*2*pi*f*(tao(k)-d/2))));
    Dis_out_MBOC(k) = (corrE_MBOC^2-corrL_MBOC^2)/(corrE_MBOC^2+corrL_MBOC^2);
    
    %BPSK(1)
    corr_BPSK1=(trapz(f,PSD_BPSK1_norm.*exp(1i*2*pi*f*(tao(k)))));
    corrResults_BPSK1(k) = real(corr_BPSK1);
    
    corrL_BPSK1=real(trapz(f,PSD_BPSK1_norm.*exp(1i*2*pi*f*(tao(k)+d/2))));
    corrE_BPSK1=real(trapz(f,PSD_BPSK1_norm.*exp(1i*2*pi*f*(tao(k)-d/2))));
    Dis_out_BPSK1(k) = (corrE_BPSK1^2-corrL_BPSK1^2)/(corrE_BPSK1^2+corrL_BPSK1^2);
    
    %Hybrid_BOC
    corr_Hybrid_BOC=(trapz(f,PSD_Hybrid_BOC_norm.*exp(1i*2*pi*f*(tao(k)))));
    corrResults_Hybrid_BOC(k) = real(corr_Hybrid_BOC);
    
    corrL_Hybrid_BOC=real(trapz(f,PSD_Hybrid_BOC_norm.*exp(1i*2*pi*f*(tao(k)+d/2))));
    corrE_Hybrid_BOC=real(trapz(f,PSD_Hybrid_BOC_norm.*exp(1i*2*pi*f*(tao(k)-d/2))));
    Dis_out_Hybrid_BOC(k) = (corrE_Hybrid_BOC^2-corrL_Hybrid_BOC^2)/(corrE_Hybrid_BOC^2+corrL_Hybrid_BOC^2);
    
end
figure;
% plot(tao/Tc_11,corrResults_MBOC,'r',tao/Tc_11,corrResults_BPSK1,'m',tao/Tc_11,corrResults_Hybrid_BOC,'g','LineWidth',2);
plot(tao/Tc_11,corrResults_MBOC,tao/Tc_11,corrResults_BPSK1,tao/Tc_11,corrResults_Hybrid_BOC,'LineWidth',2);
grid on;
xlabel('���ӳ�(Tc)');
ylabel('��һ������غ���');
legend('MBOC(6,1,1/11)','BPSK(1)','Hybrid BOC');

figure;
% plot(tao/Tc_11,Dis_out_MBOC,'r',tao/Tc_11,Dis_out_BPSK1,'m',tao/Tc_11,Dis_out_Hybrid_BOC,'LineWidth',2);
plot(tao/Tc_11,Dis_out_MBOC,tao/Tc_11,Dis_out_BPSK1,tao/Tc_11,Dis_out_Hybrid_BOC,'LineWidth',2);
grid on;
xlabel('ʵ������λ����(Tc)');
ylabel('���������');
axis([-1 1 -1.2 1.2]);
legend('MBOC(6,1,1/11)','BPSK(1)','Hybrid BOC');
