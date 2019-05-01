clc;
clear;
close all;
%% 参数设置
BW=4*1.023e6;
%% 初始化
c=CA_code(1);%得到CA码序列1
L_CA=length(c);%CA码序列长度

n_BPSK=2;%BPSK(1)
Rc_BPSK=n_BPSK*1.023e6;%码速率
Tc_BPSK=1/Rc_BPSK;%码片长度

f_sample=100e6;%采样频率
T_sample=1/f_sample;
Tp=1e-3-T_sample;%相干积分时间1ms

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