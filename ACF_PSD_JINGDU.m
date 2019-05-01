%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%接收带宽：36*1.023MHz
%作者：王博弈
%相关器间隔：0.05Tc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear;
close all;
%% 参数设置
BW=100*1.023e6;
% PowerRatio_3 = 3;
% 
% Power_TMBOC_3 = (PowerRatio_3)/(PowerRatio_3+1);
% Power_BPSK_3 = 1 - Power_TMBOC_3;
% 
% PowerRatio_2 = 2;
% 
% Power_TMBOC_2 = (PowerRatio_2)/(PowerRatio_2+1);
% Power_BPSK_2 = 1 - Power_TMBOC_2;

%% 初始化
c=CA_code(1);%得到CA码序列1
L_CA=length(c);%CA码序列长度

m_11=1;n_11=1;%BOC(1,1)
Rc_11=n_11*1.023e6;%码速率
Tc_11=1/Rc_11;%码片长度
fs_11=m_11*1.023e6;

m_105=10;n_105=5;%BOC(10,5)
Rc_105=n_105*1.023e6;%码速率
Tc_105=1/Rc_105;%码片长度
fs_105=m_105*1.023e6;

m_142=14;n_142=2;%BOC(14,2)
Rc_142=n_142*1.023e6;%码速率
Tc_142=1/Rc_142;%码片长度
fs_142=m_142*1.023e6;

n_BPSK=1;%BPSK(1)
Rc_BPSK=n_BPSK*1.023e6;%码速率
Tc_BPSK=1/Rc_BPSK;%码片长度

f_sample=200e6;%采样频率
T_sample=1/f_sample;
Tp=1e-3-T_sample;%相干积分时间1ms

N=1000;
C_N0_dB = linspace(20,50,N);
C_N0 = 10.^(C_N0_dB/10);

N_BW=100000;
f=linspace(-BW/2,BW/2,N_BW);

d = 0.02*Tc_BPSK;
%% 求功率谱
%BOC（1,1）功率谱
PSD_BOCs_11  = PSDcal_BOCs(f, fs_11, Tc_11);

%BOC（10,5）功率谱
PSD_BOCs_105  = PSDcal_BOCs(f, fs_105, Tc_105);
%BOC（14,2）功率谱
PSD_BOCs_142  = PSDcal_BOCs(f, fs_142, Tc_142);


%BPSK的归一化功率谱功率谱
PSD_R  = PSDcal_R(f, Tc_BPSK);


figure;
plot(f/1e6,10*log10(PSD_BOCs_11),'-',f/1e6,10*log10(PSD_BOCs_105),'-.',f/1e6,10*log10(PSD_BOCs_142),'--',f/1e6,10*log10(PSD_R),':','LineWidth',2);
% axis([f(1)/1e6,f(end)/1e6,-100,-60]);
axis([-20,20,-100,-60]);
grid on;
xlabel('Frequency[MHz]');
ylabel('Normalized Power Spectrum Density[dBW/Hz]');
legend('BOC(1,1)','BOC(10,5)','BOC(14,2)','BPSK(1)');
saveas(gcf,'PSD.fig');

%% EMLP精度
BL=1;
codetrack_BPSK1=jingdu_EMLP(f,PSD_R,BL,d,Tc_BPSK,Tp,C_N0);
codetrack_BOC11=jingdu_EMLP(f,PSD_BOCs_11,BL,d,Tc_11,Tp,C_N0);
codetrack_BOC_105=jingdu_EMLP(f,PSD_BOCs_105,BL,d,Tc_105,Tp,C_N0);
codetrack_BOC_142=jingdu_EMLP(f,PSD_BOCs_142,BL,d,Tc_142,Tp,C_N0);

figure;
plot(C_N0_dB,codetrack_BPSK1,'-',C_N0_dB,codetrack_BOC11,'--',...
    C_N0_dB,codetrack_BOC_105,'-.',C_N0_dB,codetrack_BOC_142,':','LineWidth',2);
grid on;
legend('BPSK(1)','BOC(1,1)','BOC(10,5)','BOC(14,2)');
% nummarkers(h4,20);
xlabel('CNR[dB-Hz]');
ylabel('EMLP code tracking error[m]');
saveas(gcf,'jingdu.fig');

% figure;plot(C_N0_dB,20*log10(codetrack_BPSK1/codetrack_BOC_142));

% title('EMLP环路的码跟踪均方误差');
%% 画出相关函数
N_tao=601;
tao=linspace(-1.05*Tc_11,1.05*Tc_11,N_tao);
C=1;

for k=1:N_tao
    %BOC(1,1)
    corr_BOC_11=(trapz(f,PSD_BOCs_11.*exp(1i*2*pi*f*(tao(k)))));
    corrResults_BOC_11(k) = real(corr_BOC_11);
end
tao=linspace(-1.05*Tc_BPSK,1.05*Tc_BPSK,N_tao);
%     corrL_BOC_11=real(trapz(f_11,PSD_BOCs_11.*exp(1i*2*pi*f_11*(tao(k)+d_11/2))));
%     corrE_BOC_11=real(trapz(f_11,PSD_BOCs_11.*exp(1i*2*pi*f_11*(tao(k)-d_11/2))));
%     Dis_out_BOC_11(k) = (corrE_BOC_11^2-corrL_BOC_11^2)/(corrE_BOC_11^2+corrL_BOC_11^2);
%     Dis_out_BOC_11(k) = (corrE_BOC_11^2-corrL_BOC_11^2);
%     Dis_out_BOC_11(k) = (corrE_BOC_11-corrL_BOC_11)/(corrE_BOC_11+corrL_BOC_11);
for k=1:N_tao
    %BOC(1,1)
    corr_BPSK1=(trapz(f,PSD_R.*exp(1i*2*pi*f*(tao(k)))));
    corrResults_BPSK1(k) = real(corr_BPSK1);
end    
    %BPSK(1)
tao=linspace(-1.05*Tc_105,1.05*Tc_105,N_tao);
for k=1:N_tao
    corr_BOC_105=(trapz(f,PSD_BOCs_105.*exp(1i*2*pi*f*(tao(k)))));
    corrResults_BOC_105(k) = real(corr_BOC_105);
end      
%     corrL_BPSK1=real(trapz(f_11,PSD_R.*exp(1i*2*pi*f_11*(tao(k)+d_BPSK/2))));
%     corrE_BPSK1=real(trapz(f_11,PSD_R.*exp(1i*2*pi*f_11*(tao(k)-d_BPSK/2))));
%    Dis_out_BPSK1(k) = (corrE_BPSK1^2-corrL_BPSK1^2)/(corrE_BPSK1^2+corrL_BPSK1^2); 
%     Dis_out_BPSK1(k) = (corrE_BPSK1^2-corrL_BPSK1^2);
%    Dis_out_BPSK1(k) = (corrE_BPSK1-corrL_BPSK1)/(corrE_BPSK1+corrL_BPSK1); 
    
    %BOC(10,5)
%     corr_BOC_105=(trapz(f,PSD_BOCs_105.*exp(1i*2*pi*f*(tao(k)))));
%     corrResults_BOC_105(k) = real(corr_BOC_105);
    
%     corrL_BOC_105=real(trapz(f_11,PSD_BOCs_105.*exp(1i*2*pi*f_11*(tao(k)+d_105/2))));
%     corrE_BOC_105=real(trapz(f_11,PSD_BOCs_105.*exp(1i*2*pi*f_11*(tao(k)-d_105/2))));
%     Dis_out_BOC_105(k) = (corrE_BOC_105^2-corrL_BOC_105^2)/(corrE_BOC_105^2+corrL_BOC_105^2);
%     Dis_out_BOC_105(k) = (corrE_BOC_105^2-corrL_BOC_105^2);
%     Dis_out_BOC_105(k) = (corrE_BOC_105-corrL_BOC_105)/(corrE_BOC_105+corrL_BOC_105);
 tao=linspace(-1.05*Tc_142,1.05*Tc_142,N_tao);
 for k=1:N_tao
    corr_BOC_142=(trapz(f,PSD_BOCs_142.*exp(1i*2*pi*f*(tao(k)))));
    corrResults_BOC_142(k) = real(corr_BOC_142);
end  
    %BOC(14,2)

    
%     corrL_BOC_142=real(trapz(f_11,PSD_BOCs_142.*exp(1i*2*pi*f_11*(tao(k)+d_142/2))));
%     corrE_BOC_142=real(trapz(f_11,PSD_BOCs_142.*exp(1i*2*pi*f_11*(tao(k)-d_142/2))));
%     Dis_out_BOC_142(k) = (corrE_BOC_142^2-corrL_BOC_142^2)/(corrE_BOC_142^2+corrL_BOC_142^2);
%     Dis_out_BOC_142(k) = (corrE_BOC_142^2-corrL_BOC_142^2);
%     Dis_out_BOC_142(k) = (corrE_BOC_142-corrL_BOC_142)/(corrE_BOC_142+corrL_BOC_142);


%     Dis_out(k) = (corrE^2-corrL^2);
% end

%% 画自相关函数
figure;
% plot(tao/Tc_11,corrResults_BOC_11,'--',tao/Tc_11,corrResults_BPSK1,'-.',tao/Tc_11,corrResults_BOC_105,'-',tao/Tc_11,corrResults_BOC_142,':','LineWidth',2);
plot(tao/Tc_11,corrResults_BOC_11,'LineWidth',2);legend('BOC(1,1)');xlabel('Code Delay(Tc)');ylabel('Normalized Auto Correlation Function');grid on;axis([-1,1,-1,1]);saveas(gcf,'ACF_BOC11.fig'); 
plot(tao/Tc_BPSK,corrResults_BPSK1,'LineWidth',2);legend('BPSK(1)');xlabel('Code Delay(Tc)');ylabel('Normalized Auto Correlation Function');grid on;axis([-1,1,-1,1]);saveas(gcf,'ACF_BPSK1.fig'); 
plot(tao/Tc_105,corrResults_BOC_105,'LineWidth',2);legend('BOC(10,5)');xlabel('Code Delay(Tc)');ylabel('Normalized Auto Correlation Function');grid on;axis([-1,1,-1,1]);saveas(gcf,'ACF_BOC105.fig'); 
plot(tao/Tc_142,corrResults_BOC_142,'LineWidth',2);legend('BOC(14,2)');xlabel('Code Delay(Tc)');ylabel('Normalized Auto Correlation Function');grid on;axis([-1,1,-1,1]);saveas(gcf,'ACF_BOC142.fig'); 
% plot(f/1e6,10*log10(PSD_BOCs_11),'-',f/1e6,10*log10(PSD_BOCs_105),'-.',f/1e6,10*log10(PSD_BOCs_142),'--',f/1e6,10*log10(PSD_R),':','LineWidth',2);
% grid on;
% % axis([-1,1,-1,1]);
% xlabel('Code Delay(Tc)');
% ylabel('Normalized Auto Correlation Function');
% legend('BOC(1,1)','BPSK(1)','BOC(10,5)','BOC(14,2)');
% saveas(gcf,'ACF.fig');

% %% 画鉴别曲线
% figure;
% plot(tao/Tc_11,Dis_out_BOC_11,'--',tao/Tc_11,Dis_out_BPSK1,'-.',tao/Tc_11,Dis_out_BOC_105,'-',tao/Tc_11,Dis_out_BOC_142,':','LineWidth',2);
% grid on;
% xlabel('Code Delay(Tc)');
% ylabel('Normalized Discriminator Output(Tc)');
% % axis([-.1 .1 -1 1]);
% legend('BOC(1,1)','BPSK(1)','BOC(10,5)','BOC(14,2)');
% saveas(gcf,'DisCurve.fig');
% %% 求MBOC相对BPSK+TMBOC的旁瓣高度倍数，单位dB
% [MBOC,locs]=min(corrResults_BOC_11);
% [BPSK_TMBOC_3,locs]=min(corrResults_BPSK_TMBOC_3);
% [BPSK_TMBOC_2,locs]=min(corrResults_BPSK_TMBOC_2);
% 
% MBOC_to_BPSK_TMBOC_3_dB=20*log10(MBOC/BPSK_TMBOC_3)
% MBOC_to_BPSK_TMBOC_2_dB=20*log10(MBOC/BPSK_TMBOC_2)