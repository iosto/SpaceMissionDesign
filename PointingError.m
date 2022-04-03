% author: Iosto Fodde
% constants: OCDM (Wertz 2nd edition)

clear all
close all
clc
format long

D = 2716000; % distance S/C to target
epsilon = 0.37708; % Angle surface to S/C as seen from target

%% Analytical computation

input_err_nadir = [0.0015,0.0020, 0.0001,0.0001,0.0010, 0.0020, 0.0010,0.0001]; %errors: Star Sensor meas, Star Senser Mounting, Star Catalog, Attitude, Payload sensor meas, Target Centroiding, Payload sensor mount, Transformation, Orbit det, Timing 

input_err_nadir = deg2rad(input_err_nadir);

mapp_err_nadir = input_err_nadir.* D ./(sin(epsilon));

mapp_err = [mapp_err_nadir , 100, 50*10^(-3)*7.35*10^3];

RSS_analytic = rssq(mapp_err);

%% +systematic error


input_sys_err_nadir = [0.0,0.0, 0.0,0.0,0.0, 0.0, 0.005,0.0];

input_sys_err_nadir = deg2rad(input_sys_err_nadir);

mapp_sys_err_nadir = input_sys_err_nadir.* D ./(sin(epsilon));

mapp_sys_err = [mapp_sys_err_nadir , 0.0, 0.0] ;

RSS_analytic_sys = rssq(mapp_sys_err);

tot_err = rssq([RSS_analytic_sys,RSS_analytic]);



%% Monte Carlo

%no systematic error
n = 100000;
nom_angle = 68.4;% angle ssp to target, degrees
h = 1000; %altitude, km
nom_xssp = 0; % sub sat point, km
nom_xtarg = nom_xssp+h.*tan(deg2rad(nom_angle)); % target location
sigma_deg = [0.0015,0.0020, 0.0001,0.0001,0.0010, 0.0020, 0.0010,0.0001];
sigma_ssp = 10^(-3).*[100, 50*10^(-3)*7.35*10^3]; %orb det and timing error
x_target = [];
diff = [];
for i = 1:n
    error_deg = sigma_deg.*randn(1,8);
    tot_error_deg = sum(error_deg);
    error_ssp = sigma_ssp.*randn(1,2);
    tot_error_ssp = sum(error_ssp);
    x_target = [x_target, (nom_xssp+tot_error_ssp)+h.*tan(deg2rad(nom_angle+tot_error_deg))];
    diff = [diff,  (nom_xssp+tot_error_ssp)+h.*tan(deg2rad(nom_angle+tot_error_deg))-nom_xtarg  ];
end
figure;
h_ns_1 = histogram(x_target);
str = sprintf('mean: %f, rms: %f, std: %f', mean(x_target), rms(x_target), std(x_target));
title(str);xlabel('x of target(km)'); ylabel('number of occurences');
figure;
h_ns_2 = histogram(diff);
str = sprintf('mean: %f, rms: %f, std: %f', mean(diff), rms(diff), std(diff));
title(str);xlabel('delta x)'); ylabel('number of occurences');

%with systematic error
sys_error_deg = [0,0,0,0,0,0,0.005,0];
x_target = [];
diff = [];
for i = 1:n
    error_deg = sigma_deg.*randn(1,8);
    error_deg = sys_error_deg + error_deg;
    tot_error_deg = sum(error_deg);
    error_ssp = sigma_ssp.*randn(1,2);
    tot_error_ssp = sum(error_ssp);
    x_target = [x_target, (nom_xssp+tot_error_ssp)+h.*tan(deg2rad(nom_angle+tot_error_deg))];
    diff = [diff,  (nom_xssp+tot_error_ssp)+h.*tan(deg2rad(nom_angle+tot_error_deg))-nom_xtarg  ];
end
figure;
h_s_1 = histogram(x_target);
str = sprintf('mean: %f, rms: %f, std: %f', mean(x_target), rms(x_target), std(x_target));
title(str);xlabel('x of target(km)'); ylabel('number of occurences');
figure;
h_s_2 = histogram(diff);
str = sprintf('mean: %f, rms: %f, std: %f', mean(diff), rms(diff), std(diff));
title(str);xlabel('delta x'); ylabel('number of occurences');