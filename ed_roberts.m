function [ nim,mod,nimx,nimy ] = ed_roberts( im , threshold)
%ED_ROBERTS Aplica mascara roberts para detección de bordes 
%

f_x = [ 1 0; 0 -1];
f_y = [ 0 1; -1 0];

nimx = aplicar_filtro(double(im),double(f_x),1,1);
nimy = aplicar_filtro(double(im),double(f_y),1,1);

mod = abs(nimx) + abs(nimy);
if threshold == 0
    [M,N] = size(im);
    threshold = mean(reshape(mod,1,M*N));
end

nim = ( mod >= threshold);

end

