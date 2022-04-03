function param = daxis(rho1,rho2,phi1,phi2,omega1,omega2)
delta = 90 - acosd(cosd(rho1)*cosd(rho2)+sind(rho1)*sind(rho2)*cosd(phi2));
dalpha = acos2((cosd(rho2)-cosd(rho1)*sind(delta))/(sind(rho1)*cosd(delta)),phi2,1);
dalpha = rad2deg(dalpha);
alpha = mod(phi1+dalpha,360);
deltaE_co = atand(omega2*sind(rho1)/(omega1+omega2*cosd(rho1)));
rhoE = acosd(cosd(deltaE_co)*sind(delta)+sind(deltaE_co)*cosd(delta)*cosd(dalpha));
omegaE = sqrt(omega1^2+omega2^2+2*omega1*omega2*cosd(rho1));
v = omegaE*sind(rhoE);
dpsi = acos2((cosd(deltaE_co)-cosd(rhoE)*sind(delta))/(sind(rhoE)*cosd(delta)),dalpha,0);
dpsi = rad2deg(dpsi);
psi = mod(dpsi-90,360);

ver = [delta,dalpha, alpha, deltaE_co, rhoE, omegaE*pi/180, v*pi/180, dpsi,psi];
param = ver';