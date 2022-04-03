function dv = deltav(deltai, i_leo, v_gtop, v_gtoa, v_geo, v_leo)
    %Calculate deltav for leo to geo transfer.
    % input should be in degrees and m/s
    deltai = deg2rad(deltai);
    i_leo = deg2rad(i_leo);
    a = (v_leo.^2 + v_gtop.^2 - 2.*v_leo.*v_gtop.*cos(deltai)).^(0.5);
    b = (v_geo.^2 + v_gtoa.^2 - 2.*v_geo.*v_gtoa.*cos(i_leo - deltai)).^(0.5);
    dv = a+b;
end