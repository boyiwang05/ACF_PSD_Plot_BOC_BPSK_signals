function [s,t]=yt_BOCc_function(c,t_begin,t_end,Tc,fs,fsample)
%c��һ�������ڵ���Ƶ������
%t_begin��ʼʱ��
%t_end��ֹʱ��
%Tc��Ƭ���
%fs���ز�Ƶ��
%fsample����Ƶ��
L_code=length(c);
Ts=1/fs;
t=t_begin:1/fsample:t_end;
N_Tc=mod(floor(t/Tc),L_code)+1;%ÿ��ʱ����Ӧ����
code=c(N_Tc);
Subcarrier=sign(sin(floor((t+Ts/4)*fs*2)*pi+pi/2));
s=code.*Subcarrier;