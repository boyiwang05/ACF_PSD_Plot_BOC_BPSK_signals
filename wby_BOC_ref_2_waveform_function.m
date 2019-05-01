%for M=2����BOC(1,1)
function [s1,s2,t]=wby_BOC_ref_2_waveform_function(c,t_begin,t_end,Tc,fs,fsample)
%c��һ�������ڵ���Ƶ������
%t_begin��ʼʱ��
%t_end��ֹʱ��
%Tc��Ƭ���
%fs���ز�Ƶ��
%fsample����Ƶ��
fc=1/Tc;
Ts=1/fs/2;
M=fs/fc*2;%ֻ����MΪż��
L_code=length(c);
t=t_begin:1/fsample:t_end;
L_t=length(t);
N_Tc=mod(floor(t/Tc),L_code)+1;%ÿ��ʱ����Ӧ����
code=c(N_Tc);
t_mod=mod(t,Tc);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% N_Tc_behind=mod(floor(t/Tc),L_code)+2;
% N_Tc_behind=mod(N_Tc_behind,L_code);
% N_Tc_behind(N_Tc_behind==0)=L_code;
% code_behind=c(N_Tc_behind);

% N_Tc_front=mod(floor(t/Tc),L_code);
% N_Tc_front(N_Tc_front==0)=L_code;
% code_front=c(N_Tc_front);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s1=zeros(1,L_t);s2=zeros(1,L_t);

index1=t_mod<=Ts & t_mod>0 ;

s1(index1)=1;
s1=sqrt(2)*s1.*code;
% else
%     N_odd=floor(t/Tc);
%     s1(index_left)=(-1).^(N_odd(index_left)).*code(index_left)+(-1).^(N_odd(index_left)-1).*code_front(index_left);
%     s1(index_right)=(-1).^(N_odd(index_right)).*code(index_right)+(-1).^(N_odd(index_right)+1).*code_behind(index_right);      
% end
% s1=s1*sqrt(M)/2;
%%
index_2=t_mod>Ts & t_mod<=Tc;
s2(index_2)=-1;
s2=sqrt(2)*s2.*code;