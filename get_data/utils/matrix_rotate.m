function R = matrix_rotate(axis, radians)
    %Produce rotation transform matrix about axis through origin.
    s = sin(radians);
    c = cos(radians);
    C = 1 - c;
    u = axis / norm(axis);
    x = u(1);
    y = u(2);
    z = u(3);
    R = [[ x*x*C + c,   x*y*C - z*s, x*z*C + y*s ];...
            [ y*x*C + z*s, y*y*C + c,   y*z*C - x*s ];...
            [ z*x*C - y*s, z*y*C + x*s, z*z*C + c   ]];
end