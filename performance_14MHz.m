%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����������MBOC(6,1,1/11)��BPSK(1)��BPSK(1)+TMBOC(6,1,4/33)���ܱȽ�
%���մ���14*1.023MHz
%���ߣ�������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear;
close all;
%% ��������
BW = 14*1.023e6;

PowerRatio_2 = 2;%���ݵ�Ƶ���ʱ�Ϊ1:2
Power_TMBOC_2 = (PowerRatio_2)/(PowerRatio_2+1);
Power_BPSK_2 = 1 - Power_TMBOC_2;

PowerRatio_3 = 3;%���ݵ�Ƶ���ʱ�Ϊ1:3
Power_TMBOC_3 = (PowerRatio_3)/(PowerRatio_3+1);
Power_BPSK_3 = 1 - Power_TMBOC_3;
%% ��ʼ��
Rc1 = 1.023e6;
Tc1 = 1/Rc1;
% Rc2 = 2*1.023e6;
% Tc2 = 1/Rc2;
fs1 = 1*1.023e6;
fs6 = 6*1.023e6;

Rb = 50;

% BW = 20e6;
N=1000;
f=linspace(-BW/2,BW/2,N);%�źŻ���Ƶ��
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

%% ��������
PSD_BPSK1 = PSDcal_R(f,Tc1);

PSD_MBOC61 = 1/11*PSDcal_BOCs(f,fs6,Tc1)+10/11*PSDcal_BOCs(f,fs1,Tc1);

PSD_BOCs_11  = PSDcal_BOCs(f, fs1, Tc1);
PSD_BOCs_61  = PSDcal_BOCs(f, fs6, Tc1);
PSD_TMBOC = 29/33*PSD_BOCs_11+4/33*PSD_BOCs_61;
PSD_BPSK1_TMBOC_2 = Power_TMBOC_2*PSD_TMBOC+Power_BPSK_2*PSD_BPSK1;%���ݵ�Ƶ���ʱ�Ϊ1:2
PSD_BPSK1_TMBOC_3 = Power_TMBOC_3*PSD_TMBOC+Power_BPSK_3*PSD_BPSK1;%���ݵ�Ƶ���ʱ�Ϊ1:3


PSD_BPSK1_norm = PSD_BPSK1/trapz(f,PSD_BPSK1);
PSD_MBOC61_norm = PSD_MBOC61/trapz(f,PSD_MBOC61);
PSD_BPSK1_TMBOC_2_norm = PSD_BPSK1_TMBOC_2/trapz(f,PSD_BPSK1_TMBOC_2);%���ݵ�Ƶ���ʱ�Ϊ1:2
PSD_BPSK1_TMBOC_3_norm = PSD_BPSK1_TMBOC_3/trapz(f,PSD_BPSK1_TMBOC_3);%���ݵ�Ƶ���ʱ�Ϊ1:3


%% ���ܱȽ�
%%%%%%%%%%%%%%��ɻ�·���������½�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sigma_code_BPSK1 = sqrt(CramerRao(f,PSD_BPSK1_norm,BL,C_N0))*c;
sigma_code_MBOC61 = sqrt(CramerRao(f,PSD_MBOC61_norm,BL,C_N0))*c;
sigma_code_BPSK1_TMBOC_2 = sqrt(CramerRao(f,PSD_BPSK1_TMBOC_2_norm,BL,C_N0))*c;%���ݵ�Ƶ���ʱ�Ϊ1:2
sigma_code_BPSK1_TMBOC_3 = sqrt(CramerRao(f,PSD_BPSK1_TMBOC_3_norm,BL,C_N0))*c;%���ݵ�Ƶ���ʱ�Ϊ1:3


figure;
h3 = plot(C_N0_dB,sigma_code_BPSK1,'-',C_N0_dB,sigma_code_MBOC61,'--',...
          C_N0_dB,sigma_code_BPSK1_TMBOC_2,'-.',C_N0_dB,sigma_code_BPSK1_TMBOC_3,':','LineWidth',2);
grid on;
legend('BPSK(1)','MBOC(6,1,1/11)','BPSK(1)+TMBOC(6,1,4/33),���ʱ�1:2','BPSK(1)+TMBOC(6,1,4/33),���ʱ�1:3');
xlabel('�����[dB-Hz]');
ylabel('��������[m]');
title('��ɻ�·���������½�');
% 
% %%%%%%%%%%%%%EMLP��·������پ������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
codetrack_BPSK1=jingdu_EMLP(f,PSD_BPSK1_norm,BL,d,Tc1,Tp,C_N0);
codetrack_MBOC61=jingdu_EMLP(f,PSD_MBOC61_norm,BL,d,Tc1,Tp,C_N0);
codetrack_BPSK1_TMBOC_2=jingdu_EMLP(f,PSD_BPSK1_TMBOC_2_norm,BL,d,Tc1,Tp,C_N0);
codetrack_BPSK1_TMBOC_3=jingdu_EMLP(f,PSD_BPSK1_TMBOC_3_norm,BL,d,Tc1,Tp,C_N0);

figure;
h4 = plot(C_N0_dB,codetrack_BPSK1,'-',C_N0_dB,codetrack_MBOC61,'--', ...
          C_N0_dB,codetrack_BPSK1_TMBOC_2,'-.',C_N0_dB,codetrack_BPSK1_TMBOC_3,':','LineWidth',2);
grid on;
legend('BPSK(1)','MBOC(6,1,1/11)','BPSK(1)+TMBOC(6,1,4/33),���ʱ�1:2','BPSK(1)+TMBOC(6,1,4/33),���ʱ�1:3');
% nummarkers(h4,20);
xlabel('�����[dB-Hz]');
ylabel('EMLP����������[m]');
title('EMLP��·������پ������');
% 
% % % %%%%%%%%%%%%����������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Rb=50;%��������50bps
%BPSK1
[DemAntiJam_CW_BPSK1,CTrAntiJam_CW_BPSK1,DemAntiJam_MatchPSD_BPSK1,CTrAntiJam_MatchPSD_BPSK1]...
            =AntiJamQ1(f,PSD_BPSK1_norm,Rb,BW);
        DemAntiJam_CW_BPSK1
        CTrAntiJam_CW_BPSK1
        DemAntiJam_MatchPSD_BPSK1
        CTrAntiJam_MatchPSD_BPSK1
%MBOC61        
[DemAntiJam_CW_MBOC61 ,CTrAntiJam_CW_MBOC61 ,DemAntiJam_MatchPSD_MBOC61 ,CTrAntiJam_MatchPSD_MBOC61 ]...
            =AntiJamQ1(f,PSD_MBOC61_norm,Rb,BW);
        DemAntiJam_CW_MBOC61 
        CTrAntiJam_CW_MBOC61 
        DemAntiJam_MatchPSD_MBOC61 
        CTrAntiJam_MatchPSD_MBOC61 
%BPSK(1)+TMBOC(6,1,4/33),���ʱ�1:2     
[DemAntiJam_CW_BPSK1_TMBOC_2 ,CTrAntiJam_CW_BPSK1_TMBOC_2 ,DemAntiJam_MatchPSD_BPSK1_TMBOC_2 ,CTrAntiJam_MatchPSD_BPSK1_TMBOC_2 ]...
            =AntiJamQ1(f,PSD_BPSK1_TMBOC_2_norm,Rb,BW);
        DemAntiJam_CW_BPSK1_TMBOC_2 
        CTrAntiJam_CW_BPSK1_TMBOC_2 
        DemAntiJam_MatchPSD_BPSK1_TMBOC_2 
        CTrAntiJam_MatchPSD_BPSK1_TMBOC_2 
%BPSK(1)+TMBOC(6,1,4/33)�����ʱ�1:3        
[DemAntiJam_CW_BPSK1_TMBOC_3 ,CTrAntiJam_CW_BPSK1_TMBOC_3 ,DemAntiJam_MatchPSD_BPSK1_TMBOC_3 ,CTrAntiJam_MatchPSD_BPSK1_TMBOC_3 ]...
            =AntiJamQ1(f,PSD_BPSK1_TMBOC_3_norm,Rb,BW);
        DemAntiJam_CW_BPSK1_TMBOC_3 
        CTrAntiJam_CW_BPSK1_TMBOC_3 
        DemAntiJam_MatchPSD_BPSK1_TMBOC_3 
        CTrAntiJam_MatchPSD_BPSK1_TMBOC_3 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%���ྶ%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % ��������
    d = 0.05*Tc1;
    alpha_dB=-10;                      % �ྶֱ����ȱ�   dB
    del_dist= 0:1:300;                  % ·����           m
    temp_del_dist  = [del_dist(end:-1:1),del_dist];
    
    ErrEnvelopes_BPSK1    = zeros(1,length(del_dist)*2);
    MeanEnvelopes_BPSK1   = zeros(1,length(del_dist));
    
    ErrEnvelopes_MBOC61    = zeros(1,length(del_dist)*2);
    MeanEnvelopes_MBOC61   = zeros(1,length(del_dist));

    ErrEnvelopes_BPSK1_TMBOC_2    = zeros(1,length(del_dist)*2);
    MeanEnvelopes_BPSK1_TMBOC_2   = zeros(1,length(del_dist));
    
    ErrEnvelopes_BPSK1_TMBOC_3    = zeros(1,length(del_dist)*2);
    MeanEnvelopes_BPSK1_TMBOC_3   = zeros(1,length(del_dist));


% %----------------------------------------------------------------------%

    [ErrEnvelope_BPSK1, MeanEnvelope_BPSK1]=MultiPathTheoryCal(f,PSD_BPSK1_norm,alpha_dB,d,del_dist);
    [ErrEnvelope_MBOC61, MeanEnvelope_MBOC61]=MultiPathTheoryCal(f,PSD_MBOC61_norm,alpha_dB,d,del_dist);
    [ErrEnvelope_BPSK1_TMBOC_2, MeanEnvelope_BPSK1_TMBOC_2]=MultiPathTheoryCal(f,PSD_BPSK1_TMBOC_2_norm,alpha_dB,d,del_dist);
    [ErrEnvelope_BPSK1_TMBOC_3, MeanEnvelope_BPSK1_TMBOC_3]=MultiPathTheoryCal(f,PSD_BPSK1_TMBOC_3_norm,alpha_dB,d,del_dist);
    
    ErrEnvelopes_BPSK1 = [ErrEnvelope_BPSK1(1,end:-1:1),ErrEnvelope_BPSK1(2,:)];
    ErrEnvelopes_MBOC61 = [ErrEnvelope_MBOC61(1,end:-1:1),ErrEnvelope_MBOC61(2,:)];
    ErrEnvelopes_BPSK1_TMBOC_2 = [ErrEnvelope_BPSK1_TMBOC_2(1,end:-1:1),ErrEnvelope_BPSK1_TMBOC_2(2,:)];
    ErrEnvelopes_BPSK1_TMBOC_3 = [ErrEnvelope_BPSK1_TMBOC_3(1,end:-1:1),ErrEnvelope_BPSK1_TMBOC_3(2,:)];
    
    MeanEnvelopes_BPSK1 = MeanEnvelope_BPSK1;    
    MeanEnvelopes_MBOC61 = MeanEnvelope_MBOC61;
    MeanEnvelopes_BPSK1_TMBOC_2 = MeanEnvelope_BPSK1_TMBOC_2;
    MeanEnvelopes_BPSK1_TMBOC_3 = MeanEnvelope_BPSK1_TMBOC_3;


        % ���ྶ������
        figure;
        h8 = plot(temp_del_dist, ErrEnvelopes_BPSK1,'-',temp_del_dist, ErrEnvelopes_MBOC61,'--',temp_del_dist, ErrEnvelopes_BPSK1_TMBOC_2,'-.',temp_del_dist, ErrEnvelopes_BPSK1_TMBOC_3,':','LineWidth',2);
        legend('BPSK(1)','MBOC(6,1,1/11)','BPSK(1)+TMBOC(6,1,4/33),���ʱ�1:2','BPSK(1)+TMBOC(6,1,4/33),���ʱ�1:3');
        xlabel('·����(m)');
        ylabel('�ྶ���(m)');
        title('�ྶ������');
        grid on;
        
        % ��ƽ���ྶ���
        figure;
        h9 = plot(del_dist, MeanEnvelopes_BPSK1,'-',del_dist, MeanEnvelopes_MBOC61,'--',del_dist, MeanEnvelopes_BPSK1_TMBOC_2,'-.',del_dist, MeanEnvelopes_BPSK1_TMBOC_3,':','LineWidth',2);
        legend('BPSK(1)','MBOC(6,1,1/11)','BPSK(1)+TMBOC(6,1,4/33),���ʱ�1:2','BPSK(1)+TMBOC(6,1,4/33),���ʱ�1:3');
        xlabel('·����(m)');
        ylabel('ƽ���ྶ���(m)');
        title('ƽ���ྶ���');
        grid on;
%         