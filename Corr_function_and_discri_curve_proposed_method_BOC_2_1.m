%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%作者：王博弈
%功能：求鉴别曲线斜率
%信号：BOC(14,2)
%本地参考波形生成函数：wby_BOC_ref_1_waveform_function
%带宽：32*1.023MHz
%（双边）相关器间隔：0.02Tc
%结果： V1:K=14.8643
%       V2:K= 29.7287
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
clc;close all;
%%
%正弦BOC参数
c=CA_code(1);%得到CA码序列1
L_CA=length(c);%CA码序列长度
m=2;n=1;%BOC(10,5)
% m=10;n=5;%BOC(10,5)
Rc=n*1.023e6;%码速率
Tc=1/Rc;%码片长度
f_sample=200e6;%采样频率
T_sample=1/f_sample;
Tp=1e-3-T_sample;%相干积分时间1ms
fs=m*1.023e6;
Ts=1/fs/2;
%%
%%%相关器间隔
BW=100*1.023e6;d=0.02*Tc;%BOC(10,5)相关器间隔
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
N_BW=10000;
f=linspace(-BW/2,BW/2,N_BW);
PSD_BOC=PSDcal_BOCs(f, fs, Tc);
power_loss_filter_dB=10*log10(trapz(f,PSD_BOC));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C=1;%载波功率
C_N0_dB=30;
C_N0=10.^(C_N0_dB/10)-power_loss_filter_dB;
N0=C/C_N0;%单边噪声功率谱密度
%不加噪声
I_NoisePower=0;%
Q_NoisePower=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
t0=0.0*Ts;%真实传播时间，初始误差在一个码片内
t_begin=t0;
t_end=t_begin+Tp;
t_ref_begin=0;
[s_receive,t_r]=yt_BOCs_function(c,t_begin,t_end,Tc,fs,f_sample);
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%BOC%%%%%%%%%%%%%
N_zong=length(t_r);
loop=5000;

index_filter=round((BW/2)/f_sample*N_zong);
% S_receive=sqrt(2*C)*s_receive;
S_receive=s_receive;
% S_receive=S_receive/sqrt(mean(S_receive.*conj(S_receive)));
        fft_S_receive=fft(S_receive);
        fft_S_receive(index_filter+1:end-index_filter)=0;
        S_receive_filter=ifft(fft_S_receive);
        
        
%  S_receive_filter=sqrt(2*C)*s_receive;%不滤波
         S_I=real(S_receive_filter); S_Q=imag(S_receive_filter);

%%
N_tao=501;
tao=linspace(-1.5*Tc,1.5*Tc,N_tao);
h_wait=waitbar(0);
for n=1:N_tao
       
        [s1_E,s2_E,t_E]=wby_BOC_ref_1_waveform_function(c,t_begin+d/2-tao(n),t_end+d/2-tao(n),Tc,fs,f_sample);
        [s1_L,s2_L,t_L]=wby_BOC_ref_1_waveform_function(c,t_begin-d/2-tao(n),t_end-d/2-tao(n),Tc,fs,f_sample);
        
        IE1=sum(S_I.*s1_E)/N_zong;QE1=sum(S_Q.*s1_E)/N_zong;
        IL1=sum(S_I.*s1_L)/N_zong;QL1=sum(S_Q.*s1_L)/N_zong;
        
        IE2=sum(S_I.*s2_E)/N_zong;QE2=sum(S_Q.*s2_E)/N_zong;
        IL2=sum(S_I.*s2_L)/N_zong;QL2=sum(S_Q.*s2_L)/N_zong;
        
%                 
%         
%        
%         
        %% 鉴别器1
%         V(n)  =IE1*IE2+QE1*QE2-IL1*IL2-QL1*QL2;%鉴别器1
        %% 鉴别器2
          V(n) = IE1*IE2 + abs( IE1*IE2 ) + QE1*QE2 +abs( QE1*QE2 ) - ( IL1*IL2 + abs( IL1*IL2 ) + QL1*QL2 +abs( QL1*QL2 ) );%鉴别器2     
        %%
%         V2(n)=((abs(IE1)+abs(IE2)-abs(IE1-IE2))^2+(abs(QE1)+abs(QE2)-abs(QE1-QE2))^2)-((abs(IL1)+abs(IL2)-abs(IL1-IL2))^2+(abs(QL1)+abs(QL2)-abs(QL1-QL2))^2);
%         V3(n)=((abs(IE1)+abs(IE2))^2-abs(IE1^2-IE2^2))+((abs(QE1)+abs(QE2))^2-abs(QE1^2-QE2^2))-((abs(IL1)+abs(IL2))^2-abs(IL1^2-IL2^2))-((abs(QL1)+abs(QL2))^2-abs(QL1^2-QL2^2));
        
%         [s_BOC_E,t_BOC_E]=yt_BOCs_function(c,t_begin+d/2-tao(n),t_end+d/2-tao(n),Tc,fs,f_sample);
%         [s_BOC_L,t_BOC_L]=yt_BOCs_function(c,t_begin-d/2-tao(n),t_end-d/2-tao(n),Tc,fs,f_sample);
%         IE_BOC=sum(S_I.*s_BOC_E)/N_zong;QE_BOC=sum(S_Q.*s_BOC_E)/N_zong;
%         IL_BOC=sum(S_I.*s_BOC_L)/N_zong;QL_BOC=sum(S_Q.*s_BOC_L)/N_zong;
        
%         V3(n)=((IE1*IE_BOC+abs(IE2*IE_BOC))+(QE1*QE_BOC+abs(QE2*QE_BOC)))-((IL1*IL_BOC+abs(IL2*IL_BOC))+(QL1*QL_BOC+abs(QL2*QL_BOC)));
        
       %         
%         V_BOC(n)=IE_BOC^2+QE_BOC^2-IL_BOC^2-QL_BOC^2;
        %%%%%%%%%%%%BOC%%%%%%%%%%%%%%%
        %相关函数
        %%
        [s1_P,s2_P,t_P]=wby_BOC_ref_1_waveform_function(c,t_begin-tao(n),t_end-tao(n),Tc,fs,f_sample);
%         [s1_P,s2_P,t_P]=yt_modified1_reference_waveform_function(c,t_begin-tao(n),t_end-tao(n),Tc,fs,f_sample);
%         s1_P=s1_P/sqrt(mean(s1_P.*conj(s1_P)));
%         s2_P=s2_P/sqrt(mean(s2_P.*conj(s2_P)));

        R1(n)=sum(S_I.*s1_P)/N_zong;
        R2(n)=sum(S_I.*s2_P)/N_zong;
%         R_BOC(n)=sum(S_I.*s_BOC_P)/N_zong;
        
        %%
        temp_string=['已运行' num2str(floor((n/N_tao)*10000)/100) '%'];
        waitbar(n/N_tao,h_wait,temp_string);

end
close(h_wait);
% %%%%%%%%%%%%%%%
figure;plot(tao/Tc,R1.*R2,'-',tao/Tc,R1,'-.',tao/Tc,R2,'--','LineWidth',2);xlabel('Code delay [chips]');ylabel('Cross-correlation');grid on;
legend('R1*R2','R1','R2');
title('M=4')
saveas(gcf,'CCF_BOC_2_1.fig');

figure;
plot(tao/Tc,V,'LineWidth',2);
xlabel('Code delay [chips]');ylabel('Discriminator output');
% legend('V1','V2','V3');
grid on;
% figure;plot(tao/Tc,V_BOC);