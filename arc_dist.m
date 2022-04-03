function D = arc_dist(P1,P2,P3)
    %calculate arc distances between three points on a unit sphere
    %(azimuth, elevation. Returns array with three distances (D12,D13,D23)
    P1 = deg2rad(P1);
    P2 = deg2rad(P2);
    P3 = deg2rad(P3);

    D12 = acos(sin(P1(2))*sin(P2(2)) + cos(P1(2))*cos(P2(2))*cos(P1(1)-P2(1)));
    D13 = acos(sin(P1(2))*sin(P3(2)) + cos(P1(2))*cos(P3(2))*cos(P1(1)-P3(1)));
    D23 = acos(sin(P2(2))*sin(P3(2)) + cos(P2(2))*cos(P3(2))*cos(P2(1)-P3(1)));

    D12 = rad2deg(D12);
    D13 = rad2deg(D13);
    D23 = rad2deg(D23);
    D = [D12,D13,D23];
end