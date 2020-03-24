function [ nim ] = aplicar_filtro3( im, filtro )
%APLICAR_FILTRO3 [ nim ] = aplicar_filtro3( im, filtro )
%Aplica filtro a imagen aplicando la transformada de 
%Fourier a ambas señales, multiplicando trasformadas y aplicando la 
%inversa de la transformada al resultado
filtro = rot90(rot90(filtro));
[M1,N1] = size(im);
[M2,N2] = size(filtro);
M = M1 + M2 -1;
N = N1 + N2 -1;
fim = fft2(im,M,N);
ff = fft2(filtro,M,N);
nim = ifft2(fim .* ff);
nim = nim(ceil(M2/2):ceil(M2/2)+M1-1,ceil(N2/2):ceil(N2/2)+N1-1);

end

