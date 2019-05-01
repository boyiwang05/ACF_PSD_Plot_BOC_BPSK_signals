function [ErrEnvelope, MeanEnvelope]=MultiPathTheoryCal(f,PSD,alpha_dB,d,del_dist)
% 理论计算多径误差
% f:        频率向量，Hz
% PSD：      归一化功率谱密度， W/Hz
% alpha_dB:  多径直达幅度比   dB
% del_dist：距离差，m         
% ErrEnvelope：多径误差包络 m，第一行对应0 度相位，第二行对应180度相位
% MeanEnvelope：平均多径误差 m。
%d 相关器间隔


% 多径参数转换单位
alpha       = 10 ^(alpha_dB/20);
TaoValues   = del_dist/(3e8);


% 初始化结果向量
ErrEnvelope = zeros(2,length(TaoValues));  % 第一行表示0相位，第二行表示180相位
MeanEnvelope= zeros(1,length(TaoValues));  


UpPart1     = zeros(size(TaoValues));
DownPart1   = zeros(size(TaoValues));
UpPart2     = zeros(size(TaoValues));
DownPart2   = zeros(size(TaoValues));

for m = 1:length(TaoValues)
    det_tao = TaoValues(m);
    
    UpPart1(m)     = alpha * trapz(f, PSD .* sin(2*pi*f*det_tao) .*sin(pi*f*d));      % 0相位分子
    DownPart1(m)   = 2 * pi * trapz(f, f .* PSD .* (1 + alpha*cos(2*pi*f*det_tao)) .* sin(pi*f*d));    % 0相位分母
    UpPart2(m)     = -alpha * trapz(f, PSD .* sin(2*pi*f*det_tao) .*sin(pi*f*d));      % 180相位分子
    DownPart2(m)   = 2 * pi * trapz(f, f .* PSD .* (1 - alpha*cos(2*pi*f*det_tao)) .* sin(pi*f*d));    % 180相位分母
end

ErrEnvelope(1,:)   = UpPart1./DownPart1 * 3e8;
ErrEnvelope(2,:)   = UpPart2./DownPart2 * 3e8;

temp    = mean(abs(ErrEnvelope));
temp    = cumsum(temp);%第n个元素的值是钱前n个元素之和
MeanEnvelope    = temp./(1:length(TaoValues));
