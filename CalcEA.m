function E = CalcEA(M,e,tol)
    %calculate E (eccentric anomaly) using Mean anomaly M and eccentricity e
    %by using a value (tol) that defines how accurate the value
    %must be, thus it says if the value only changes by tol, it is
    %sufficiently accurate.
    tol = 10^(-12);
    Etemp = M;
    ratio = 1;
    while abs(ratio) > tol
        f_E = Etemp - e*sin(Etemp) - M;
        f_Eprime = 1 - e*cos(Etemp);
        ratio = f_E/f_Eprime;
        if abs(ratio) > tol
            Etemp = Etemp - ratio;
        else
            E = Etemp;
        end
    end
end