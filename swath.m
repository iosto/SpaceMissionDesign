function h = swath(delta,alpha, swAngle, color)
% Plot the swath on ground from the latitude and longitude (delta, alpha)
% and the swath angle (swAngle, defined as the arc on Earth) with a certain
% color.
dir = 1;
previ = 1;
for i = 1:length(delta)-1
        if (delta(i) >= 0 && (delta(i) >= delta(i+1)) && dir == 1) 
            disp(i);
            X=[delta(previ:i-1),fliplr(delta(previ:i-1))];                
            Y=[alpha(previ:i-1)-180-swAngle,fliplr(alpha(previ:i-1)-180+swAngle)]; 
            fillm(X,Y, color, 'FaceAlpha', 0.2);
            previ = i+1;
            dir = 0;
        elseif (delta(i) <= 0 && (delta(i) <= delta(i+1)) && dir == 0)
            disp(i);
            X=[delta(previ:i-1),fliplr(delta(previ:i-1))];                
            Y=[alpha(previ:i-1)-180-swAngle,fliplr(alpha(previ:i-1)-180+swAngle)]; 
            fillm(X,Y, color, 'FaceAlpha', 0.2);
            previ = i+1;
            dir = 1;
        end
end
X=[delta(previ:length(delta)),fliplr(delta(previ:length(delta)))];                
Y=[alpha(previ:length(delta))-180-swAngle,fliplr(alpha(previ:length(delta))-180+swAngle)]; 
fillm(X,Y, color, 'FaceAlpha', 0.2);

end