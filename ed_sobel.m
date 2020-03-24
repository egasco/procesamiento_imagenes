function [ nim,mod,nimx,nimy ] = ed_sobel( im,threshold )
%ED_SOBEL Aplica mascara sobel para detección de bordes 


f_x = [ -1 0 1;-2 0 2;-1 0 1];
f_y = [ 1 2 1;0 0 0;-1 -2 -1];

%nimx = aplicar_filtro2(double(im),double(f_x),0,0);
%nimy = aplicar_filtro2(double(im),double(f_y),0,0);
nimx = aplicar_filtro3(double(im),double(f_x));
nimy = aplicar_filtro3(double(im),double(f_y));
mod =  abs(nimx) + abs(nimy);
%mod = sqrt( (nimx).^2 + (nimy).^2);
if threshold == 0
    [M,N] = size(im);
    threshold = mean(reshape(mod,1,M*N));
end
nim = ( mod >= threshold);

end

