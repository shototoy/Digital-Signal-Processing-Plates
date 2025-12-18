function [x1,x2] = ACT3(x,y,z)
    d=y^2-4*x*z;
    x1=(-y+sqrt(d))/(2*x);
    x2=(-y-sqrt(d))/(2*x);
end
