%for M=4，如BOC(10,5)
function [s1,s2,t]=wby_BOC_ref_1_waveform_function_for_odd_order_BOC(c,t_begin,t_end,Tc,fs,fsample)
%c是一个码周期的扩频码序列
%t_begin起始时间
%t_end终止时间
%Tc码片宽度
%fs子载波频率
%fsample采样频率
fc=1/Tc;
Ts=1/fs/2;
M=fs/fc*2;%只考虑M为偶数
L_code=length(c);
t=t_begin:1/fsample:t_end;
L_t=length(t);
N_Tc=mod(floor(t/Tc),L_code)+1;%每个时间点对应的码
code=c(N_Tc);
t_mod=mod(t,Tc);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N_Tc_behind=mod(floor(t/Tc),L_code)+2;
N_Tc_behind=mod(N_Tc_behind,L_code);
N_Tc_behind(N_Tc_behind==0)=L_code;
code_behind=c(N_Tc_behind);

N_Tc_front=mod(floor(t/Tc),L_code);
N_Tc_front(N_Tc_front==0)=L_code;
code_front=c(N_Tc_front);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s1=zeros(1,L_t);s2=zeros(1,L_t);
index_left=t_mod<=Ts & t_mod>-Ts ;
index_right=t_mod<=Tc+Ts & t_mod>Tc-Ts;

s1(index_left)=code(index_left)-code_front(index_left);


s1(index_right)=code(index_right)-code_behind(index_right);
   
% else
%     N_odd=floor(t/Tc);
%     s1(index_left)=(-1).^(N_odd(index_left)).*code(index_left)+(-1).^(N_odd(index_left)-1).*code_front(index_left);
%     s1(index_right)=(-1).^(N_odd(index_right)).*code(index_right)+(-1).^(N_odd(index_right)+1).*code_behind(index_right);      
% end
s1=s1*sqrt(M)/2;
%%
Subcarrier_BOC=sign(sin(floor(t*fs*2)*pi+pi/2));
index_2_temp=t_mod>Ts & t_mod<=(Tc-Ts);
s2(index_2_temp)=1;
s2=sqrt(M/(M-2))*s2.*code.*Subcarrier_BOC;