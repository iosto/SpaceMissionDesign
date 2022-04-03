function a_final = repeat_orbit(i,e,j,k)
    % Calculate the semi major axis for a repeat orbit with a given
    % inclination(i), eccentricity (e), orbits(j) and days(k)
    i = deg2rad(i);
    J2 = 1082.63*10^(-6); 
    Re = 6378136; %m
    L_dot = 360; %deg/sid day
    D = 86164.1004; %seconds (LO sidereal day)
    mu = 3.98600441e14; %m^3/s^2
    a_new = (mu.*(D.*k./(2.*pi.*j)).^2).^(1/3); %initial guess semi major axis
    dif = 1;
    it = 1;
    while dif > 0.0001
        a = a_new;
        RAAN_dot = -3/2 .* J2*sqrt(mu).* Re^2 .* a.^(-3.5).*cos(i).*(1-e.^2).^(-2).*180/pi .* D; % deg/sid day
        omega_dot = 3/4 .* J2.*sqrt(mu).* Re^2 .* a.^(-3.5).*(5.*(cos(i)).^2-1).*(1-e.^2).^(-2).*180/pi .* D; % deg/sid day
        M_dot = 3/4 .* J2.*sqrt(mu).* Re^2 .* a.^(-3.5).*(3.*(cos(i)).^2-1).*(1-e.^2).^(-1.5).*180/pi .* D; % deg/sid day
        n = j./k .*(L_dot - RAAN_dot)-(omega_dot+M_dot); %deg/sid_day
        a_new = (mu./(n./D .* pi./180).^2).^(1/3); %km
        dif = abs(a-a_new);
        it = it + 1;
    end
    a_final = a;
end