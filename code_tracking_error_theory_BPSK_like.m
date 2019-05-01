clc;
clear;
close all;
%% ��������
BW=4*1.023e6;
%% ��ʼ��
c=CA_code(1);%�õ�CA������1
L_CA=length(c);%CA�����г���

n_BPSK=2;%BPSK(1)
Rc_BPSK=n_BPSK*1.023e6;%������
Tc_BPSK=1/Rc_BPSK;%��Ƭ����

f_sample=100e6;%����Ƶ��
T_sample=1/f_sample;
Tp=1e-3-T_sample;%��ɻ���ʱ��1ms

N=1000;
C_N0_dB = linspace(20,45,N);
C_N0 = 10.^(C_N0_dB/10);

N_BW=100000;
f=linspace(-BW/2,BW/2,N_BW);

d = 0.5*Tc_BPSK;
PSD_R  = PSDcal_R(f, Tc_BPSK);
BL=1;
codetrack_BPSK1=jingdu_EMLP(f,PSD_R,BL,d,Tc_BPSK,Tp,C_N0);

figure;
plot(C_N0_dB,codetrack_BPSK1/3e8/Tc_BPSK)
grid on;