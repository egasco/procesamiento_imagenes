function [ nimx,nimy,ograd,nim,grad ,dir,edgeop, edge1,edge2,edge3,umin,umax] = ed_canny(im, suavizado,direccion, operador,supresion,umin,umax )
%ED_CANNY Detector de bordes de canny
% [ nimx,nimy,ograd,nim,grad ,dir,edge1,edge2,edge3] = ed_canny(im, suavizado,direccion, operador,supresion,umin,umax )
%Entradas:
% <im> : imagen de entrada
% <operador>: 'roberts', 'prewitt' o 'sobel'
% umin: Umbral  ultizado en XXXXXX 
% umax: Umbral  ultizado
%Salidas
% nimx: d(im)/dx
% nimx: d(im)/dy
% mod: Aproximacion a modulo de gradiente de im: mod = abs(nimx) + (nimy)
% dir: Direccion de gradiente de im.
% edge1: bordes utlizando modulo de gradiente y umax
% edge2: bordes despues de deteccion de Supresion de no maximos
% edge3: bordes despues de umbralizacion con histeresis
% nim: deteccion de bordes de canny

[M1,N1] = size(im);

angles = [  0   45 90 135 ];
prev_r = [  0  -1  -1   -1];
prev_c = [ -1   1   0   -1];
next_r = [  0   1   1    1];
next_c = [  1  -1   0    1];

% Suavizado
switch suavizado
    case 1
        g = 1/273 .* [1 4 7 4 1;4 16 26 16 4;7 26 41 26 7;4 16 26 16 4;1 4 7 4 1];
        %nim = aplicar_filtro2(double(im),double(g),0,0);
        nim = aplicar_filtro3(double(im),double(g));
    case 2
        g = 1/115 .* [2 4 5 4 2;4 9 12 9 4;5 12 15 12 5;4 9 12 9 4;2 4 5 4 2];
        %nim = aplicar_filtro2(double(im),double(g),0,0);
        nim = aplicar_filtro3(double(im),double(g));
    otherwise
        nim = im;
end

%Descarto bordes en extremos de imagen, debido al padding pueden no
%reflejar bordes reales
nim(:,1:2) = repmat(nim(:,3),1,2);
nim(:,size(im,2)-1:size(im,2)) =  repmat(nim(:,size(im,2)-2),1,2);
nim(1:2,:) = repmat(nim(3,:),2,1);
nim(size(im,1)-1:size(im,1),:) = repmat(nim(size(im,1)-2,:),2,1);
    
% Gradiente y direccion
switch operador
    case 'roberts'
        [ nim,grad,nimx,nimy ] = ed_roberts( nim,0 );
    case 'prewitt'
        [ nim,grad,nimx,nimy ] = ed_prewitt( nim,0 );
    case 'sobel'
        [ nim,grad,nimx,nimy ] = ed_sobel( nim,0 );
    otherwise
        error('Operador no valido');
end
edgeop = nim;
switch direccion
    case 1
        grad = abs(nimx);
    case 2
        grad = abs(nimy);        
end
ograd = grad;

dir = atan(double(nimy) ./ double(nimx));
adir = dir + (dir < 0 ) .* pi;
adir = rad2deg(adir);


if umax == 0
    %umax = sum(reshape(mod,1,M1*N1)) / sum(sum(mod ~= 0));
    umin = 2 * mean(reshape(grad,1,M1*N1));
    umax = 3/2 * umin;
end

edge1 = not(grad > umax);

%Supresion de no maximos
nim = ones(M1,N1);

switch supresion
    case 1
        [I,J] = find( grad >= umax );
        for v = 1:length(I)
                i=I(v);
                j=J(v);
                [val,z] =  min(abs(angles - adir(i,j)));
                %r = i;c=j;
                if ( i+prev_r(z) > 0 && j+prev_c(z) > 0 && i+prev_r(z) <= M1 && j+prev_c(z) <= N1 && grad(i,j) <= grad(i+prev_r(z),j+prev_c(z))) || ( i+next_r(z) > 0 && j+next_c(z) > 0 && i+next_r(z) <= M1 && j+next_c(z) <= N1 && grad(i,j) <= grad(i+next_r(z),j+next_c(z)))
                    grad(i,j) = 0;
                end     
        end
    case 2
        for i = 2:M1-1
            for j = 2:N1-1
                        %mientras que encuentre pixeles en la direccion del gradiente que
                        %que sean menor o igual a la del pixel actual y ademas superen
                        %umbral los lleva a 0        
                        [val,z] =  min(abs(angles - adir(i,j)));

                         if( grad(i,j)  > umax )
                             r=i;c=j;
                             rmax = r;cmax=c;
                             while( r < M1 && c < N1  && r > 1 && c > 1 && grad(r+next_r(z),c+next_c(z))  > umax )
                                if  grad(rmax,cmax) >= grad(r+next_r(z),c+next_c(z)) 
                                    grad(r+next_r(z),c+next_c(z)) = 0;
                                else
                                    grad(rmax,cmax) = 0;
                                    rmax=r+next_r(z);cmax = c+next_c(z);
                                end
                                r=r+next_r(z);c=c+next_c(z);
                             end
                         end      
            end
        end
    case 3
        for i = 2:M1-1
            for j = 2:N1-1
                        %mientras que encuentre pixeles en la direccion del gradiente que
                        %que sean menor o igual a la del pixel actual y ademas superen
                        %umbral los lleva a 0        
                        z = get_dir_index(adir,i,j);

                         if( grad(i,j)  > umax )
                             if(get_dir_index(adir,i+next_r(z),j+next_c(z)) ~= z) &&  (grad(i,j) <= grad(i+prev_r(z),j+prev_c(z)) || grad(i,j) <= grad(i+next_r(z),j+next_c(z)))
                                    grad(i,j) = 0; 
                             else
                                 r=i;c=j;
                                 rmax = r;cmax=c;
                                 while( r < M1 && c < N1  && r > 1 && c > 1 && grad(r+next_r(z),c+next_c(z))  > umax && get_dir_index(adir,r+next_r(z),c+next_c(z)) == z )
                                    if  grad(rmax,cmax) >= grad(r+next_r(z),c+next_c(z)) 
                                        grad(r+next_r(z),c+next_c(z)) = 0;
                                    else
                                        grad(rmax,cmax) = 0;
                                        rmax=r+next_r(z);cmax = c+next_c(z);
                                    end
                                    r=r+next_r(z);c=c+next_c(z);
                                 end
                             end
                         end      
            end
        end
    otherwise
        error('modo de supresión no valido');
end



%umax=0.5 * max(max(mod));
%umin=2/3 * umax;


nim = not(grad > umax);
edge2 = nim;


indices = find(grad > umax);
[I,J] = ind2sub(size(grad),indices);
for z= 1:length(indices)
    %obtengo direccion perpendicular
    v = I(z);
    w = J(z);
    [val,pdir] =  min(abs(angles - adir(v,w)));
    pdir = uint8(mod(pdir+1,4)) +1;
    while v < M1 && w < N1  && v > 1 && w > 1 && grad(v+next_r(pdir),w+next_c(pdir)) > umin && grad(v+next_r(pdir),w+next_c(pdir)) < umax 
        nim(v+next_r(pdir),w+next_c(pdir)) = 0;
        v = v+next_r(pdir);
        w = w+next_c(pdir);
        [val,pdir] =  min(abs(angles - adir(v,w)));
         pdir = uint8(mod(pdir+1,4)) +1;
    end
end
edge3 = nim;

end

function [z] = get_dir_index(dir,i,j)
    angles = [  0   45 90 135 ];
    [val,z] =  min(abs(angles - dir(i,j)));
end