% author: Iosto Fodde
% constants: OCDM (Wertz 2nd edition)
% This program calculates the minimum delta v needed for a transfer from
% incined LEO orbit to an GEO orbit using 3 different optimization techniques

clear all
close all
clc
format long

Re = 6378136; %m
mu = 3.98600441e14; %m^3/s^2
sid = 86164.1004; %s

r_leo = 185000+Re; %m
i_leo = 28.5; %degrees
r_geo = (mu * (sid/(2*pi))^2)^(1/3);
r_gtoa = r_geo;
r_gtop = r_leo;
a_gto = (r_gtop + r_gtoa)/2 ;
v_leo = sqrt(mu/r_leo); %m/s
v_geo = sqrt(mu/r_geo); %m/s
v_gtop = sqrt(mu.*(2/r_gtop - 1/a_gto));
v_gtoa = sqrt(mu.*(2/r_gtoa - 1/a_gto));

%% OPTIM: Gradient

deltai_0 = 10; %degrees
prev_der = 1;
deltai = deltai_0;
step = 0.5; %degrees
best_v = deltav(deltai, i_leo, v_gtop, v_gtoa, v_geo, v_leo);
plotting = [];
plotting_2 = [];
diff = 1;
func_evals = 0;
while diff > 10^-5 && func_evals < 1000
    der = d_deltav(deltai, i_leo, v_gtop, v_gtoa, v_geo, v_leo);
    if der < 0 && prev_der == -1
        deltai = deltai+step;
        prev_der = -1;
        diff = abs(best_v - deltav(deltai, i_leo, v_gtop, v_gtoa, v_geo, v_leo));
        best_v = deltav(deltai, i_leo, v_gtop, v_gtoa, v_geo, v_leo);
    elseif der < 0 && prev_der ~= -1
        step = 0.5*step;
        deltai = deltai+step;
        prev_der = -1;
        diff = abs(best_v - deltav(deltai, i_leo, v_gtop, v_gtoa, v_geo, v_leo));
        best_v = deltav(deltai, i_leo, v_gtop, v_gtoa, v_geo, v_leo);
    elseif der > 0 && prev_der == 1
        deltai = deltai - step;
        prev_der = 1;
        diff = abs(best_v - deltav(deltai, i_leo, v_gtop, v_gtoa, v_geo, v_leo));
        best_v = deltav(deltai, i_leo, v_gtop, v_gtoa, v_geo, v_leo);
    elseif der > 0 && prev_der ~= 1
        step = 0.5*step;
        deltai = deltai-step;
        prev_der = 1;   
        diff = abs(best_v - deltav(deltai, i_leo, v_gtop, v_gtoa, v_geo, v_leo));
        best_v = deltav(deltai, i_leo, v_gtop, v_gtoa, v_geo, v_leo);
    elseif der == 0
        break
    end
    plotting = [plotting, best_v];
    plotting_2 = [plotting_2, deltai];
    func_evals = func_evals + 1;
end
figure;
plot(linspace(1,func_evals, func_evals), plotting, '-x');
xlabel('number of evaluations'); ylabel('delta V');
figure;
plot(linspace(1,func_evals, func_evals), plotting_2, '-x');
xlabel('number of evaluations'); ylabel('delta i_1');

%% OPTIM Monte-Carlo

samples = [50,100,500];
for i = 1:3
    random_i = i_leo .* rand(samples(i),1);
    dv = deltav(random_i, i_leo, v_gtop, v_gtoa, v_geo, v_leo);
    [min_dv , index] = min(dv);
    min_di1 = random_i(index);
    min_di2 = i_leo - random_i(index);
    figure;
    plot(random_i, dv, '.');
    hold on
    plot(min_di1, min_dv, '*', 'MarkerSize', 15);
    xlabel('delta i_1'); ylabel('delta V'); title(['samples: ' num2str(samples(i)) ', min = ' num2str(min_di1) 'degrees']);
    hold off
end

%% OPTIM-4 Grid


samples = [50,100,500];
for i = 1:3
    di = linspace(0,28.5, samples(i));
    dv = deltav(di, i_leo, v_gtop, v_gtoa, v_geo, v_leo);
    [min_dv , index] = min(dv);
    min_di1 = di(index);
    min_di2 = i_leo - di(index);
    figure;
    plot(di, dv, '.');
    hold on
    plot(min_di1,min_dv, '*', 'MarkerSize', 15);
    xlabel('delta i_1'); ylabel('delta V'); title(['samples: ' num2str(samples(i)) ', min = ' num2str(min_di1) 'degrees']);
    hold off
end
