function [alpha, delta, psi, v] = groundTrack(h, i, tf)
% Show the ground track of a satellite in a circular orbit
% Input:
% h = altitude
% i = inclination
% tf = final tima
% Output:
% alpha = long
% delta = lat
% psi = flight path angle
%  v = ground track angular velocity

Re = 6378.136; %km
mu = 398600.441; %km^3/s^2
period = 2*pi*sqrt((Re+h)^3/(mu));%seconds
n = 2*pi/period;
omega_day = 2*pi/86164.1004;
dalpha_orb = omega_day * period;
rho1 = i;
rho2 = 90;
omega1 = -omega_day*180/pi;
omega2 = n*180/pi;
time = linspace(0,tf,period-1);
alpha = zeros(size(time));
delta = zeros(size(time));
psi = zeros(size(time));
v = zeros(size(time));

for i = 1:length(time)
    param = daxis(rho1,rho2,omega1*time(i),omega2*time(i),omega1,omega2);
    alpha(i) = param(3);
    delta(i) = param(1);
    psi(i) = param(9);
    v(i) = param(7);
end

worldmap world
load coastlines
[latcells, loncells] = polysplit(coastlat, coastlon);
numel(latcells);
plotm(coastlat, coastlon);
hold on
plotm(delta,alpha-180, 'k.');
swath(delta, alpha, 40, 'k')

