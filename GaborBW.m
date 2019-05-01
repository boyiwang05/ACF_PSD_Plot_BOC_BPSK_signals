%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%代码描述：MBOC(6,1,1/11)、BPSK(1)、BPSK(1)+TMBOC(6,1,4/33)Gabor带宽比较
%作者：王博弈
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear;
close all;
% 初始化
N_BW = 1000;
BW = linspace(0,25e6,N_BW);
% BW = [ 4.096e6 14.322e6 24.552e6 ];
% N_BW = 3;
% BW = 4*1.023e6
PowerRatio_2 = 2;%数据导频功率比为1:2
Power_TMBOC_2 = (PowerRatio_2)/(PowerRatio_2+1);
Power_BPSK_2 = 1 - Power_TMBOC_2;

PowerRatio_3 = 3;%数据导频功率比为1:3
Power_TMBOC_3 = (PowerRatio_3)/(PowerRatio_3+1);
Power_BPSK_3 = 1 - Power_TMBOC_3;
Rc1 = 1.023e6;
Tc1 = 1/Rc1;
fs1 = 1*1.023e6;
fs6 = 6*1.023e6;
Rb = 50;
%% 计算Gabor带宽
for k = 1:N_BW
    N=1000;
    f=linspace(-BW(k)/2,BW(k)/2,N);%信号基带频率
    C_N0_dB = linspace(20,50,N);
    C_N0 = 10.^(C_N0_dB/10);
    BL = 1;
    d = 0.05;
    c = 3e8;
    Tp = 1e-3;
    t1 = linspace(-Tc1,Tc1,N/10);
    % t2 = linspace(-Tc2,Tc2,N/10);
    R_BPSK1 = zeros(1,N/10);
    R_BPSK2 = zeros(1,N/10);
    R_MBOC61 = zeros(1,N/10);

    %% 画功率谱
    PSD_BPSK1 = PSDcal_R(f,Tc1);

    PSD_MBOC61 = 1/11*PSDcal_BOCs(f,fs6,Tc1)+10/11*PSDcal_BOCs(f,fs1,Tc1);

    PSD_BOCs_11  = PSDcal_BOCs(f, fs1, Tc1);
    PSD_BOCs_61  = PSDcal_BOCs(f, fs6, Tc1);
    PSD_TMBOC = 29/33*PSD_BOCs_11+4/33*PSD_BOCs_61;
    PSD_BPSK1_TMBOC_2 = Power_TMBOC_2*PSD_TMBOC+Power_BPSK_2*PSD_BPSK1;%数据导频功率比为1:2
    PSD_BPSK1_TMBOC_3 = Power_TMBOC_3*PSD_TMBOC+Power_BPSK_3*PSD_BPSK1;%数据导频功率比为1:3


    PSD_BPSK1_norm = PSD_BPSK1/trapz(f,PSD_BPSK1);
    PSD_MBOC61_norm = PSD_MBOC61/trapz(f,PSD_MBOC61);
    PSD_BPSK1_TMBOC_2_norm = PSD_BPSK1_TMBOC_2/trapz(f,PSD_BPSK1_TMBOC_2);%数据导频功率比为1:2
    PSD_BPSK1_TMBOC_3_norm = PSD_BPSK1_TMBOC_3/trapz(f,PSD_BPSK1_TMBOC_3);%数据导频功率比为1:3
    % % % %%%%%%%%%%%%Gabor带宽%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Gabor_BPSK1(k)=20*log10(sqrt(trapz(f,f.^2.*PSD_BPSK1_norm))/1e6);
    Gabor_MBOC61(k)=20*log10(sqrt(trapz(f,f.^2.*PSD_MBOC61_norm))/1e6);
    Gabor_BPSK1_TMBOC_2(k)=20*log10(sqrt(trapz(f,f.^2.*PSD_BPSK1_TMBOC_2_norm))/1e6);
    Gabor_BPSK1_TMBOC_3(k)=20*log10(sqrt(trapz(f,f.^2.*PSD_BPSK1_TMBOC_3_norm))/1e6);
end

    figure;
    h4 = plot(BW/1e6,Gabor_BPSK1,'-',BW/1e6,Gabor_MBOC61,'--', ...
              BW/1e6,Gabor_BPSK1_TMBOC_2,'-.',BW/1e6,Gabor_BPSK1_TMBOC_3,':','LineWidth',2);
    grid on;
    legend('BPSK(1)','MBOC(6,1,1/11)','BPSK(1)+TMBOC(6,1,4/33),功率比1:2','BPSK(1)+TMBOC(6,1,4/33),功率比1:3');
    % nummarkers(h4,20);
    xlabel('前端带宽[MHz]');
    ylabel('Gabor带宽[dBMHz]');
    % 