function angle = acos2(arg, inp_angle, inverse)
    if 0 <= mod(inp_angle,360) && mod(inp_angle,360) < 180 
        if inverse == 0
            H = 1;
        else
            H = -1;
        end
    elseif 180 <= mod(inp_angle,360) && mod(inp_angle,360) < 360 
        if inverse == 0
            H = -1;
        else
            H = 1;
        end
    end
    if arg>1
        arg = 1;
    end
    angle = mod(H*acos(arg),2*pi);
        
end