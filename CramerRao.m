function sigma = CramerRao(f,PSD,BL,C_N0)
sigma = BL./C_N0./4./pi./pi./trapz(f,f.^2.*PSD);