function der = d_deltav(deltai, i_leo, v_gtop, v_gtoa, v_geo, v_leo)
    %Calculate the derivative of deltav wrt delta i_1. 
    % input should be in degrees and m/s
    deltai = deg2rad(deltai);
    i_leo = deg2rad(i_leo);
    a = 1/2.*(v_leo.^2 + v_gtop.^2 - 2.*v_leo.*v_gtop.*cos(deltai)).^(-0.5) .* 2.* v_leo .* v_gtop .* sin(deltai);
    b = 1/2.*(v_geo.^2 + v_gtoa.^2 - 2.*v_geo.*v_gtoa.*cos(i_leo - deltai)).^(-0.5) .* 2.* v_geo .* v_gtoa .* sin(i_leo - deltai);
    der = a-b;
end