clc;
clear;
close all;
%% 参数设置
BW=1000*1.023e6;

%% 初始化
c=CA_code(1);%得到CA码序列1
L_CA=length(c);%CA码序列长度

m=14;n=2;%BOC(1,1)
Rc=n*1.023e6;%码速率
Tc=1/Rc;%码片长度
fs=m*1.023e6;

f_sample=2000e6;%采样频率
T_sample=1/f_sample;
Tp=1e-3-T_sample;%相干积分时间1ms
N_BW=100000;
f=linspace(-BW/2,BW/2,N_BW);
PSD_BOCs  = PSDcal_BOCs(f, fs, Tc);

N_tao=601;
 tao=linspace(-1.05*Tc,1.05*Tc,N_tao);
 for k=1:N_tao
    corr_BOC=(trapz(f,PSD_BOCs.*exp(1i*2*pi*f*(tao(k)))));
    corrResults_BOC(k) = real(corr_BOC);
end  


%% 画自相关函数
figure;
plot(tao/Tc,corrResults_BOC,'LineWidth',2);legend('BOC(14,2)');xlabel('Code Delay(Tc)');ylabel('Normalized Auto Correlation Function');grid on;axis([-1.05,1.05,-1,1.05]);saveas(gcf,'ACF_BOC142.fig'); 
