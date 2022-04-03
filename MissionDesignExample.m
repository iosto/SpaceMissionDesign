% author: Iosto Fodde
% Mission design analysis for an arctic rescue: 
% Design a satellite search and rescue mission that is able to pick up distress signals from any location (land,
% sea, ice) in the area north of the Arctic Circle, and report this to a ground station in Kiruna, Sweden.
% Maximum delay time between picking up the signal and delivering it in Sweden is four hours. Mission
% lifetime is 5 years.
% Assumptions:
%  - payload mass (i.e., total mass of instruments) is 10 kg.
%  - Only address the orbital aspects, including launch, maintenance, relation with communication target(s),
%     etcetera.
% constants: OCDM (Wertz 2nd edition)

clear all
close all
clc
format long

%% Ground tracks and mapping

Re = 6378.136; %km
mu = 398600.441; %km^3/s^2

period = 1.6*60*60;%seconds
n = 2*pi/period;
omega_day = 2*pi/86164.1004;
i = 90.0;
dalpha_orb = omega_day * period;
rho1 = i;
rho2 = 90;
omega1 = -omega_day*180/pi;
omega2 = n*180/pi;
time = linspace(0,period,period-1);
alpha = zeros(size(time));
delta = zeros(size(time));
psi = zeros(size(time));
v = zeros(size(time));

for i = 1:length(time)
    param = daxis(rho1,rho2,omega1*time(i)+27,omega2*time(i)-50,omega1,omega2);
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
plotm(delta,alpha-180, '.');
plotm(ones(1,100).*66 , linspace(-180,180,100),'k--')
plotm(67,20,'x','linewidth',8);

r1=90 - 5 - asind(Re/(Re+550) * cosd(5));
x = 20;
y = 67;
ang=0:0.01:2*pi; 
xp=r1*cos(ang);
yp=r1*sin(ang);
plotm(y+yp,x+xp, 'k-');

r2=90  - asind(Re/(Re+550) * cosd(0));
x = 20;
y = 67;
ang=0:0.01:2*pi; 
xp=r2*cos(ang);
yp=r2*sin(ang);
plotm(y+yp,x+xp, 'r-');

hold off

%% Swath calculation

inc = [66,70,80,90];
figure;
linesp = {'-','--',':','-.'};
for i = 1:4
    x = linspace(25, 90, 1000);
    y = 2*asind(sqrt(sind(inc(i)).^(-2) * sind(x/2).^2));
    hold on
    %yyaxis left
    plot(x,360./y, linesp{i})
    ylabel('number of orbits for full coverage');
    %yyaxis right
    %height = Re - ((360./(y*omega_day*180/pi*2*pi)).^2 * mu).^(1/3);
    %plot(x,height)
    %hline = refline([0 550]);
    %hline.Color = 'r';
    %plot( 90 - 5 - asind(Re ./(Re+height) * cosd(5)) ,height );
    %text(23,600,'h = 550 km', 'Interpreter', 'latex')
    %line([90 - 5 - asind(Re/(Re) * cosd(5)) 90 - 5 - asind(Re/(Re+2000) * cosd(5))],[0 2000], 'Color', 'k' , 'LineStyle', '-' );
    %line([90 - asind(Re/(Re) * cosd(0)) 90 - asind(Re/(Re+2000) * cosd(0))],[0 2000], 'Color', 'k' , 'LineStyle', '-' );
    %text(22,1700,'$\epsilon = 0$', 'Interpreter', 'latex')
    %axis([15,25,0,2000])
    %ylabel('orbital height [km]');
end
grid on;
xlabel('swath width [degrees]');
%text(23,600,'h = 550 km', 'Interpreter', 'latex', 'Fontsize', 12)
legend('i = 66', 'i = 70','i = 80','i = 90');

%% 

figure;
hold on
epsilons = [0,1,2,3,4,5];
for i =1:6
    height = linspace(0,2000,100);
    lambdas = 90 - epsilons(i) - asind(Re./(Re+height) .* cosd(epsilons(i)));    
    plot( height,lambdas);
end
ylabel('$\lambda_{max}$ [degrees]','Interpreter', 'latex','Fontsize', 14);
xlabel('orbital height [km]');
h = legend('$\epsilon_{min} = 0 $','$\epsilon_{min} = 1 $','$\epsilon_{min} = 2 $','$\epsilon_{min} = 3 $','$\epsilon_{min} = 4 $','$\epsilon_{min} = 5 $');
set(h,'Interpreter','latex')
grid on
hold off

figure;
Legend2 = cell(6,1);
inclinations = linspace(66,90,100);
j = linspace(10,16,7);
a_repeat = zeros(1,100);
hold on
for i = 1:6
    for n = 1:100
        a_repeat(n) = repeat_orbit(inclinations(n), 0, j(i), 1);
    end
    plot(a_repeat*10^(-3) - Re,inclinations);
    Legend2{i} = strcat('j = ', num2str(j(i)));
end
legend(Legend2);
ylabel('inclination [deg]');
xlabel('orbital height [km]');
hold off

figure;
Legend2 = cell(6,1);
inclinations = linspace(66,90,100);
j = linspace(10,16,7);
a_repeat = zeros(1,100);
hold on
for i = 1:6
    for n = 1:100
        a_repeat(n) = repeat_orbit(inclinations(n), 0, j(i), 1);
    end
    plot((2.*pi.*sqrt((a_repeat.*10^(-3)).^3 ./ mu) ./3600) .* j(i),inclinations);
    Legend2{i} = strcat('j = ', num2str(j(i)));
end
legend(Legend2);
ylabel('inclination [deg]');
xlabel('repeat time [hours]');
hold off

 
r1 = (185+Re);
r2 = (800+Re);
n = r2/r1;
dv_1 = sqrt(mu/r1) * (sqrt(2*n/(n+1))-1);
dv_2 = sqrt(mu/r1) * (sqrt(1/n)*(1-sqrt(2/(n+1))));

dRAAN_1 = 45;
dRAAN_2 = 90;
dv_3_1 =  sqrt(mu/r2) * 2*sind(90)*sind(0.5*dRAAN_1);
dv_3_2 =  sqrt(mu/r2) * 2*sind(90)*sind(0.5*dRAAN_1);
dv_3_3 =  sqrt(mu/r2) * 2*sind(90)*sind(0.5*dRAAN_2);

dv_stat = 0.001;
dv_disp = sqrt(mu/r2) * (0.5*(800-75)/(2*Re+185+800));

dv_tot = dv_1+dv_2+dv_3_1+dv_3_2+dv_3_3+dv_stat+dv_disp;

r1 = (185+Re);
r2 = (40178+Re);
e = 0.7493;
n = r1/(0.5*(300+r2));
dv_1 = sqrt(mu/r1) * (sqrt(2/((1+e)*(1+e+n)))*(1+e-n)+sqrt(n*(1-e)/(1+e))-1);


dRAAN_1 = 120;
dv_3_1 =  sqrt(mu/r2) * 2*sind(64.3)*sind(0.5*dRAAN_1);
dv_3_2 =  sqrt(mu/r2) * 2*sind(64.3)*sind(0.5*dRAAN_1);


dv_stat = 0.001;
dv_disp = sqrt(mu/r2) * (0.5*(r2-75)/(2*Re+185+r2));

dv_tot = dv_1+dv_3_1+dv_3_2+dv_stat*3+dv_disp*3;

%% Ground track for multiple sats

clear all
close all
clc
format long

Re = 6378.136; %km
mu = 398600.441; %km^3/s^2

h = 785;
period = 2*pi*sqrt((Re+h)^3/(mu));%seconds
n = 2*pi/period;
omega_day = 2*pi/86164.1004;
i = 90.0;
dalpha_orb = omega_day * period;
rho1 = i;
rho2 = 90;
omega1 = -omega_day*180/pi;
omega2 = n*180/pi;
time = linspace(0,4*60*60,period-1);
alpha = zeros(size(time));
delta = zeros(size(time));
psi = zeros(size(time));
v = zeros(size(time));

for i = 1:length(time)
    param = daxis(rho1,rho2,omega1*time(i)+0,omega2*time(i)-1,omega1,omega2);
    alpha(i) = param(3);
    delta(i) = param(1);
    psi(i) = param(9);
    v(i) = param(7);
end

alpha2 = zeros(size(time));
delta2 = zeros(size(time));
psi2 = zeros(size(time));
v2 = zeros(size(time));

for i = 1:length(time)
    param = daxis(rho1,rho2,omega1*time(i)+45,omega2*time(i)-50,omega1,omega2);
    alpha2(i) = param(3);
    delta2(i) = param(1);
    psi2(i) = param(9);
    v2(i) = param(7);
end


alpha3 = zeros(size(time));
delta3 = zeros(size(time));
psi3 = zeros(size(time));
v3 = zeros(size(time));

for i = 1:length(time)
    param = daxis(rho1,rho2,omega1*time(i)+90,omega2*time(i)-100,omega1,omega2);
    alpha3(i) = param(3);
    delta3(i) = param(1);
    psi3(i) = param(9);
    v3(i) = param(7);
end

alpha4 = zeros(size(time));
delta4 = zeros(size(time));
psi4 = zeros(size(time));
v4 = zeros(size(time));

for i = 1:length(time)
    param = daxis(rho1,rho2,omega1*time(i)+135,omega2*time(i)-179,omega1,omega2);
    alpha4(i) = param(3);
    delta4(i) = param(1);
    psi4(i) = param(9);
    v4(i) = param(7);
end

worldmap world
load coastlines
[latcells, loncells] = polysplit(coastlat, coastlon);
numel(latcells);

plotm(coastlat, coastlon);
hold on
r1=90 - 5 - asind(Re/(Re+h) * cosd(5));
x = 20;
y = 67;
ang=0:0.01:2*pi; 
xp=r1*cos(ang);
yp=r1*sin(ang);
plotm(y+yp,x+xp, 'k-');

swath(delta,alpha,r1,'k');
swath(delta2,alpha2,r1,'r');
swath(delta3,alpha3,r1,'y');
swath(delta4,alpha4,r1,'b');


plotm(delta,alpha-180, 'k.');
%plotm(delta,alpha-180+r1, 'k--');
%plotm(delta,alpha-180-r1, 'k--');
plotm(delta2,alpha2-180, 'r.');
%plotm(delta2,alpha2-180+r1, 'r--');
%plotm(delta2,alpha2-180-r1, 'r--');
plotm(delta3,alpha3-180, 'y.');
%plotm(delta3,alpha3-180+r1, 'y--');
%plotm(delta3,alpha3-180-r1, 'y--');
plotm(delta4,alpha4-180, '.');
%plotm(delta4,alpha4-180+r1, '--');
%plotm(delta4,alpha4-180-r1, '--');
plotm(ones(1,100).*66 , linspace(-180,180,100),'k--')
plotm(67,20,'x','linewidth',8);

