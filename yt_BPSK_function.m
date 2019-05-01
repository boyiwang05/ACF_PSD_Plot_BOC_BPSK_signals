function [s,t]=yt_BPSK_function(c,t_begin,t_end,Tc,fsample)
%c是一个码周期的扩频码序列
%t_begin起始时间
%t_end终止时间
%Tc码片宽度
%fs子载波频率
%fsample采样频率
L_code=length(c);
t=t_begin:1/fsample:t_end;
N_Tc=mod(floor(t/Tc),L_code)+1;%每个时间点对应的码
code=c(N_Tc);
s=code;