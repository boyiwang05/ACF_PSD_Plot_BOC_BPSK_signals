%%%%%%%%%%%%%%%%%%%%%%%% BPSK-R功率谱计算 %%%%%%%%%%%%%%%%%%%%
function PSD_R  = PSDcal_R(f, Tc)
%计算矩形码片的功率谱密度
% f : Hz
% Tc: s，码片长度
PSD_R   = Tc .* ((sinc(f.*Tc)).^2);