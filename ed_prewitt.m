function [ nim,mod, nimx,nimy ] = ed_prewitt( im ,threshold )
%ED_PREWITT Aplica mascara prewitt para detección de bordes 

f_x = [ -1 0 1;-1 0 1;-1 0 1];
f_y = [ 1 1 1;0 0 0;-1 -1 -1];

nimx = aplicar_filtro2(double(im),double(f_x),0,0);
nimy = aplicar_filtro2(double(im),double(f_y),0,0);

mod = abs(nimx) + abs(nimy);

if threshold == 0
    [M,N] = size(im);
    threshold = mean(reshape(mod,1,M*N));
end

nim = ( mod >= threshold);
end

