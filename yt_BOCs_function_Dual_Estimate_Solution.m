function [s,t]=yt_BOCs_function_Dual_Estimate_Solution(c,t_code_begin,t_code_end,t_Subcarrier_begin,t_Subcarrier_end,Tc,fs,fsample)
%c是一个码周期的扩频码序列
%t_begin起始时间
%t_end终止时间
%Tc码片宽度
%fs子载波频率
%fsample采样频率
L_code=length(c);
t_code=t_code_begin:1/fsample:t_code_end;
t_Subcarrier=t_Subcarrier_begin:1/fsample:t_Subcarrier_end;
N_Tc=mod(floor(t_code/Tc),L_code)+1;%每个时间点对应的码
code=c(N_Tc);
Subcarrier=sign(sin(floor(t_Subcarrier*fs*2)*pi+pi/2));
% Subcarrier=sin(2*pi*fs*t);
s=code.*Subcarrier;
t=t_code;