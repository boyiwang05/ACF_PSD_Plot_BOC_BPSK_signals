%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%作者：王博弈
%功能：求鉴别曲线斜率
%信号：BOC(14,2)
%本地参考波形生成函数：yt_BPSK_function
%带宽：4*1.023MHz
%（双边）相关器间隔：d=0.25*Tc
%结果： K= 2.6107
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
clc;
close all
%BPSK_like,上下边带都使用
%%
%正弦BOC参数
c=CA_code(1);%得到CA码序列1
L_CA=length(c);%CA码序列长度
m=1;k=1;%BOC(14,2)
Rc=k*1.023e6;%码速率
Tc=1/Rc;%码片长度
f_sample=100e6;%采样频率
T_sample=1/f_sample;
Tp=1e-3-T_sample;%相干积分时间1ms
fs=m*1.023e6;
Ts=1/fs/2;
%%
%%%相关器间隔
BW=4*1.023e6;d=0.5*Tc;%相关器间隔，BOC(14,2)相关器间隔

% BW=10*1.023e6;d=0.5*Tc;%BOC(10,5)相关器间隔

% BW=4*1.023e6;d=0.5*Tc;%BOC(1,1)相关器间隔
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N_BW=10000;
f=linspace(-BW/2,BW/2,N_BW);
PSD_BOC=PSDcal_BOCs(f, fs, Tc);
power_loss_filter_dB=10*log10(trapz(f,PSD_BOC));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
C=1;%载波功率
C_N0_dB=20-power_loss_filter_dB;
C_N0=10.^(C_N0_dB/10);
N0=C/C_N0;%单边噪声功率谱密度
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %不加噪声
I_NoisePower=0;%
Q_NoisePower=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
N_tao=501;
tao=linspace(-Tc,Tc,N_tao);
R_BPSK_like=zeros(1,N_tao);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
t_begin=0;
[S_CA_receiver,t_receiver]=yt_BPSK_function(c,t_begin,t_begin+Tp,Tc,f_sample);
h_wait=waitbar(0);
for k=1:N_tao
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [s_E,t_E]=yt_BPSK_function(c,t_begin-tao(k)+d/2,t_begin-tao(k)+Tp+d/2,Tc,f_sample); 
    [s_P,t_P]=yt_BPSK_function(c,t_begin-tao(k),t_begin-tao(k)+Tp,Tc,f_sample);
    [s_L,t_L]=yt_BPSK_function(c,t_begin-tao(k)-d/2,t_begin-tao(k)+Tp-d/2,Tc,f_sample);
    %%
    N_zong=length(t_P);   
%     S_receiver_I=sqrt(2*C)*S_CA_receiver+sqrt(I_NoisePower)*randn(1,N_zong);
    S_receiver_I=S_CA_receiver+I_NoisePower*randn(1,N_zong);
    S_receiver_Q=sqrt(Q_NoisePower)*randn(1,N_zong);
    
    %%
    %下边带
    fft_sig  = fft((S_receiver_I + 1i*S_receiver_Q));
    L_res   = round(BW/f_sample/2*N_zong);
    fft_sig(L_res+1:end-L_res)  = 0;
    sigBandL = ifft(fft_sig);
    RecSigI = real(sigBandL);
    RecSigQ = imag(sigBandL);
    
    %%    
    IE=sum(RecSigI.*s_E)/N_zong;QE=sum(RecSigQ.*s_E)/N_zong;
        
%     IE_up=sum(RecSigI_up.*s_E)/N_zong;QE_up=sum(RecSigQ_up.*s_E)/N_zong;
    
    IP=sum(RecSigI.*s_P)/N_zong;QP=sum(RecSigQ.*s_P)/N_zong;
        
%     IP_up=sum(RecSigI_up.*s_P)/N_zong;QP_up=sum(RecSigQ_up.*s_P)/N_zong;
            
    IL=sum(RecSigI.*s_L)/N_zong;QL=sum(RecSigQ.*s_L)/N_zong;
                
%     IL_up=sum(RecSigI_up.*s_L)/N_zong;QL_up=sum(RecSigQ_up.*s_L)/N_zong;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%             
     R_BPSK_like(k)=(IP^2+QP^2);%相关函数
     
     Discriminator_out(k)=((IE^2+QE^2)-(IL^2+QL^2))/( (IE^2+QE^2)+(IL^2+QL^2) );
         
    temp_string=['已运行' num2str(ceil(k/N_tao*10000)/100) '%'];
    waitbar(k/N_tao,h_wait,temp_string);
end

close(h_wait);
%%
% figure;
% plot(tao/Tc,R_BPSK_like);grid on;

figure;
plot(tao/Tc,Discriminator_out);grid on;
saveas(gcf,'DIS_BPSK.fig');