function [s,t]=yt_BPSK_function(c,t_begin,t_end,Tc,fsample)
%c��һ�������ڵ���Ƶ������
%t_begin��ʼʱ��
%t_end��ֹʱ��
%Tc��Ƭ���
%fs���ز�Ƶ��
%fsample����Ƶ��
L_code=length(c);
t=t_begin:1/fsample:t_end;
N_Tc=mod(floor(t/Tc),L_code)+1;%ÿ��ʱ����Ӧ����
code=c(N_Tc);
s=code;