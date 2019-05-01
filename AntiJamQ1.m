function [DemAntiJam_CW,CTrAntiJam_CW,DemAntiJam_MatchPSD,CTrAntiJam_MatchPSD]...
    =AntiJamQ1(f,PSD,Rd,Bf)
% 抗干扰能力分析
% f:   相对载波频率偏移   Hz
% PSD:  归一化功率谱密度  W/Hz
% Rd:   数据速率         bps
% DemAntiJam_CW:    解调抗窄带  dB
% CTrAntiJam_CW:    跟踪抗窄带  dB
% DemAntiJam_MatchPSD:  解调抗匹配谱  dB
% CTrAntiJam_MatchPSD:  跟踪抗匹配谱  dB

% 前端带宽小于发射带宽 
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