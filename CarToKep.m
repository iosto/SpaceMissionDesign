function kep = CarToKep(s)
    % s = [x,y,z,xdot,ydot,zdot]
    kep = zeros(6,1);
    mu = 3.98600441 * 10^14; %m^3/s^2
    %compute all vectors needed for transformation
    R = [s(1),s(2),s(3)];
    r = sqrt(s(1)^2+s(2)^2+s(3)^2);
    V = [s(4),s(5),s(6)];
    v = sqrt(s(4)^2+s(5)^2+s(6)^2);
    H = cross(R,V);
    h = sqrt(H(1)^2+H(2)^2+H(3)^2);
    N = cross([0,0,1], H);
    n = sqrt(N(1)^2+N(2)^2+N(3)^2);
    E = cross(V,H)/mu - R/r;
    e = sqrt(E(1)^2+E(2)^2+E(3)^2);
    %calculate kepler elements
    kep(1) = e;
    kep(2) = (2/r - v^2/mu)^(-1);
    kep(3) = acos(H(3)/h);
    x1 = N(2)/sqrt(N(1)^2+N(2)^2);
    x2 = N(1)/sqrt(N(1)^2+N(2)^2);
    kep(4) = atan2(x1, x2);
    %sign if statements
    if dot(cross(N/n, E), H)>0
        kep(5) = acos(dot(E/e,N/n));
    else
        kep(5) = -acos(dot(E/e,N/n));
    end

    if dot(cross(E, R), H)>0
        theta = acos(dot(R/r,E/e));
    else
        theta = -acos(dot(R/r,E/e));
    end
    E = 2*atan(sqrt((1-e)/(1+e))*tan(theta/2));
    kep(6) = E-e*sin(E);

    kep(3) = rad2deg(kep(3));
    kep(4) = rad2deg(kep(4));
    kep(5) = rad2deg(kep(5));
    kep(6) = rad2deg(kep(6));
    %kep = [e,a,i,Omega,w,M]
end