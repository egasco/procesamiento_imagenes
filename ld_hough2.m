function [ l_lines,r_lines,line_count,luh,ruh ] = ld_hough2( im, ev,delta,luh,ruh,max_lines)
%HOUGH [ lines,A,lc,ruh,luh ] = ld_hough2( im, ev,delta,ruh,luh,dtheta,drho,max_lines)
%   Aplica transformada de Hough. En la mitad izquierda se buscan rectas
%   con rho positivo y andgulo de 0 a pi/2. En la mitad derecha se busca
%   rectas de con theta > pi/2
%Entrada:
% im:        Imagen con bordes
% ev:        Valor de borde.
% delta:     Valor con que se discretiza delta, menor variacion identificada.
% luh:      Umbral para lineas izquierdas en hough, de ser se usa 0.9 max(max(A)) donde A es la matriz acumuladoras de lineas de seccion izquierda
% ruh:      Umbral para lineas derechas en hough, de ser se usa 0.9 max(max(A)) donde A es la matriz acumuladora de lineas de seccion  derecha
% max_lines Limita cantidad de lineas que devuelve la funcion

%Salida
% l_lines:      Vector con listas seleccionadas de la mitad izquierda de la imagen
% r_lines:      Vector con listas seleccionadas de la mitad derecha de la imagen
% line_count:   Rectas detectadas por hough
% luh:          Umbral para lineas izquierdas en hough
% ruh:          Umbral para lineas derechas en hough

    [M,N1] = size(im);

    
    N2 = round(N1/2);
    theta = [ 0:delta:pi-delta ];
    TL = length(theta);

    im(:,1) = 1 - ev;
    im(:,N1) =  1 - ev;
    im(1,:) =  1 - ev;
    im(M,:) =  1 - ev;

    % calculo seno y coseno para thetas
    persistent s;
    persistent c;
    if isempty(s)
        s= sin(theta);
        strcat('Calculo Senos')
    end
    if isempty(c)
        c= cos(theta);
        strcat('Calculo Cosenos')
    end

    %Proceso Seccion izquierda de imagen 
    d = norm([M, N2]) + 1;
    % calculo valores de rho
    [y, x] = find(im(:,1:N2) == ev);
    P = length(x);
    RHO = floor([x, y] * [c(1:TL/2); s(1:TL/2)] );

    % Creo Acumulador limito angulo hasta pi/2 (TL/2)
    A = full(sparse(round(RHO+d), repmat(1 : TL/2, [P, 1]), 1));
    
    %Busco lineas con  rho postivo
    LA=A(round(d)+1:end,1:end);
    %Si no se especifico umbral, se utiliza 90% del maximo 
    if luh == 0
        luh = max(max(LA)) * 0.9;
    end
    
    l_idx = find( LA >= luh);
    [trash,sidx] = sort(-1 * LA(l_idx));
    l_sidx = l_idx(sidx);
    [lr,lt] = ind2sub(size(LA),l_sidx);

    
    [y, x] = find(im(:,N2+1:N1) == ev);
    %x=x+N2;
    P = length(x);
    RHO = floor([x, y] * [c(TL/2:TL); s(TL/2:TL)] );

    % Creo Acumulador, Limto angulo de pi/2 a pi
    RA = full(sparse(round(RHO+d), repmat(TL/2 : TL, [P, 1]), 1));
    
    %Si no se especifico umbral, se utiliza 90% del maximo 
    if ruh == 0
        ruh = max(max(RA)) * 0.9;
    end
    
    r_idx = find( RA >= ruh );
    [trash,sidx] = sort(-1 * RA(r_idx));
    r_sidx = r_idx(sidx);
    [nr,nt] = ind2sub(size(RA),r_sidx);
        
    %Guardo lineas seleccionadas
    ridx=find( RA(r_sidx) > 0);
    lidx=find( LA(l_sidx) > 0);
    rc=min(sum(RA(r_idx) > 0),max_lines/2);
    lc=min(sum(LA(l_idx) > 0),max_lines/2);
    
    if( lc > 0 )
        l_lines=zeros(lc,3);
        l_lines(1:lc,2)=delta*(lt(lidx(1:lc))-1);
        l_lines(1:lc,1)=round(lr(lidx(1:lc)));
        l_lines(1:lc,3)=LA(l_sidx(lidx(1:lc)));
    end
    
    if ( rc > 0 )
        r_lines=zeros(rc,3);
        r_lines(1:rc,2)=delta*(nt(ridx(1:rc))-1);
        r_lines(1:rc,1)=-round(cos(pi-r_lines(1:rc,2)) *N2 - (nr(ridx(1:rc))-d) );
        r_lines(1:rc,3)=RA(r_sidx(ridx(1:rc)));
    end
    line_count=lc+rc;

end
