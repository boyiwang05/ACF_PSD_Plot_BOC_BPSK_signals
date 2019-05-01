function [DemAntiJam_CW,CTrAntiJam_CW,DemAntiJam_MatchPSD,CTrAntiJam_MatchPSD]...
    =AntiJamQ1(f,PSD,Rd,Bf)
% ��������������
% f:   ����ز�Ƶ��ƫ��   Hz
% PSD:  ��һ���������ܶ�  W/Hz
% Rd:   ��������         bps
% DemAntiJam_CW:    �����խ��  dB
% CTrAntiJam_CW:    ���ٿ�խ��  dB
% DemAntiJam_MatchPSD:  �����ƥ����  dB
% CTrAntiJam_MatchPSD:  ���ٿ�ƥ����  dB

% ǰ�˴���С�ڷ������ 
% Bf  = 40e6;
PSD(abs(f)>Bf/2)    = 0;

temp    = max(PSD);
DemAntiJam_CW   = -10*log10(Rd*temp);

temp    = max( f.* f .* PSD);
Gabor   = trapz(f, f.* f .* PSD);
CTrAntiJam_CW 	= -10*log10(temp/Gabor);

temp    = trapz(f, PSD .* PSD);
DemAntiJam_MatchPSD = -10*log10(Rd*temp);


temp    = trapz(f, f.* f .* PSD .* PSD);
CTrAntiJam_MatchPSD = -10*log10(temp/Gabor);