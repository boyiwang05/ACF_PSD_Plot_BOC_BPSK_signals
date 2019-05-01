function [ErrEnvelope, MeanEnvelope]=MultiPathTheoryCal(f,PSD,alpha_dB,d,del_dist)
% ���ۼ���ྶ���
% f:        Ƶ��������Hz
% PSD��      ��һ���������ܶȣ� W/Hz
% alpha_dB:  �ྶֱ����ȱ�   dB
% del_dist������m         
% ErrEnvelope���ྶ������ m����һ�ж�Ӧ0 ����λ���ڶ��ж�Ӧ180����λ
% MeanEnvelope��ƽ���ྶ��� m��
%d ��������


% �ྶ����ת����λ
alpha       = 10 ^(alpha_dB/20);
TaoValues   = del_dist/(3e8);


% ��ʼ���������
ErrEnvelope = zeros(2,length(TaoValues));  % ��һ�б�ʾ0��λ���ڶ��б�ʾ180��λ
MeanEnvelope= zeros(1,length(TaoValues));  


UpPart1     = zeros(size(TaoValues));
DownPart1   = zeros(size(TaoValues));
UpPart2     = zeros(size(TaoValues));
DownPart2   = zeros(size(TaoValues));

for m = 1:length(TaoValues)
    det_tao = TaoValues(m);
    
    UpPart1(m)     = alpha * trapz(f, PSD .* sin(2*pi*f*det_tao) .*sin(pi*f*d));      % 0��λ����
    DownPart1(m)   = 2 * pi * trapz(f, f .* PSD .* (1 + alpha*cos(2*pi*f*det_tao)) .* sin(pi*f*d));    % 0��λ��ĸ
    UpPart2(m)     = -alpha * trapz(f, PSD .* sin(2*pi*f*det_tao) .*sin(pi*f*d));      % 180��λ����
    DownPart2(m)   = 2 * pi * trapz(f, f .* PSD .* (1 - alpha*cos(2*pi*f*det_tao)) .* sin(pi*f*d));    % 180��λ��ĸ
end

ErrEnvelope(1,:)   = UpPart1./DownPart1 * 3e8;
ErrEnvelope(2,:)   = UpPart2./DownPart2 * 3e8;

temp    = mean(abs(ErrEnvelope));
temp    = cumsum(temp);%��n��Ԫ�ص�ֵ��Ǯǰn��Ԫ��֮��
MeanEnvelope    = temp./(1:length(TaoValues));
