function car = KepToCar(s)
    % s= [e,a,i,Omega,w,M]
    % input must be in degrees
    car = zeros(6,1); %create cartesian state vector
    %create input parameters
    mu = 3.98600441 * 10^14; %m^3/s^2
    %convert everythong to radians for the calculation
    s(3) = deg2rad(s(3));
    s(4) = deg2rad(s(4));
    s(5) = deg2rad(s(5));
    s(6) = deg2rad(s(6));
    l1 = cos(s(4))*cos(s(5))- sin(s(4))*sin(s(5))*cos(s(3));
    l2 = -cos(s(4))*sin(s(5))- sin(s(4))*cos(s(5))*cos(s(3));
    m1 = sin(s(4))*cos(s(5))+ cos(s(4))*sin(s(5))*cos(s(3));
    m2 = -sin(s(4))*sin(s(5))+ cos(s(4))*cos(s(5))*cos(s(3));
    n1 = sin(s(5))*sin(s(3));
    n2 = cos(s(5))*sin(s(3));
    %calculate E with iterative procedure
    E = CalcEA(s(6),s(1));
    c = sqrt((1+s(1))/(1-s(1)));
    theta=2*atan(c*tan((E/2)));
    % angular momentum
    H = sqrt(mu*s(2)*(1-s(1)^2));
    %radius
    r = (H^2/mu)/(1+s(1)*cos(theta));
    %calculate cartesian components
    vec = [l1,l2; m1,m2;n1,n2]*[r.*cos(theta);r.*sin(theta)];
    car(1) = vec(1);
    car(2) = vec(2);
    car(3) = vec(3);
    car(4) = mu/H.*(-l1.*sin(theta)+l2.*(s(1)+cos(theta)));
    car(5) = mu/H.*(-m1.*sin(theta)+m2.*(s(1)+cos(theta)));
    car(6) = mu/H.*(-n1.*sin(theta)+n2.*(s(1)+cos(theta)));
    %car = [x,y,z,xdot,ydot,zdot]
end