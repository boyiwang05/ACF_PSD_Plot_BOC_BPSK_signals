function y=jingdu_EMLP(f,PSD,BL,d,Tc,Tp,C_N0)
error_EML=BL*trapz(f,PSD.*sin(pi*f*d*Tc).^2)/pi^2/4./C_N0/(trapz(f,f.*PSD.*sin(pi*f*d*Tc)))^2;
pingfangsunhao=1+1/Tp*trapz(f,PSD.*cos(pi*f*d*Tc).^2)/(trapz(f,PSD.*cos(pi*f*d*Tc)))^2./C_N0;
y=sqrt(error_EML.*pingfangsunhao)*3e8;