function rot = rotation(arc)
    %calculate rotations around points on a unit sphere
    %Returns array with three rotations(R1,R2,R3)
    arc = deg2rad(arc);
    rot3 = acos((cos(arc(1)) - cos(arc(2))*cos(arc(3)))/(sin(arc(2))*sin(arc(3))));
    rot2 = acos((cos(arc(2)) - cos(arc(1))*cos(arc(3)))/(sin(arc(1))*sin(arc(3))));
    rot1 = acos((cos(arc(3)) - cos(arc(1))*cos(arc(2)))/(sin(arc(1))*sin(arc(2))));

    rot1 = rad2deg(rot1);
    rot2 = rad2deg(rot2);
    rot3 = rad2deg(rot3);
    rot = [rot1,rot2,rot3];
end