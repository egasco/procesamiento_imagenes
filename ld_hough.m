function [ lines,dir,grad,A,borders,lc,umin,umax,nuh,puh ] = ld_hough( im, ed,suavizado,direccion,umin,umax,delta,nuh,puh,dtheta,drho,max_lines)
%HOUGH [ lines,dir,grad,A,borders ] = ld_hough( im, ed,direccion,umin,umax,delta,uh,dtheta,drho,max_lines)
%   Detailed explanation goes here

    [M,N] = size(im);
    %strcat('ED Start   : ',datestr(now,'yyyymmdd_HHMMSS'))
    switch ed
        case 'roberts'
            [ nim,grad,nimx,nimy ] = ed_roberts( im,umax );
            ev=1;
        case 'prewitt'
            [ nim,grad,nimx,nimy ] = ed_prewitt( im,umax );
            ev=1;
        case 'sobel'
            [ nim,grad,nimx,nimy ] = ed_sobel( im,umax );
            ev=1;
        case 'canny'
            [ nimx,nimy,ograd,rnim,grad ,dir,edge1,edge2,nim,umin,umax] = ed_canny(im, suavizado, direccion,'sobel',1,umin,umax ); 
            ev=0;
        case 'none'
            nim=im;
        otherwise
            error('Operador no valido');
    end
    borders = nim;
    
    
    theta = [ 0:delta:pi-delta ];
    TL = length(theta);
    %strcat('ED END  : ',datestr(now,'yyyymmdd_HHMMSS'))
    %obtengo coordenadas de punto de borde
    nim(:,1) = 1 - ev;
    nim(:,size(im,2)) =  1 - ev;
    nim(1,:) =  1 - ev;
    nim(size(im,1),:) =  1 - ev;
    [y, x] = find(nim == ev);
    P = length(x);
    %G = grad(sub2ind(size(grad),y,x));
    %G = G/max(G);
    %G = repmat(G,[1 TL]);


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


    d = norm([M, N]) + 1;
    %strcat('A START  : ',datestr(now,'yyyymmdd_HHMMSS'))
    % calculo valores de rho
    RHO = floor([x, y] * [c; s] );

    % Creo Acumulador
    A = full(sparse(round(RHO+d), repmat(1 : TL, [P, 1]), 1));
    %A= full(sparse(round(RHO+d), repmat(1 : TL, [P, 1]), G));
    %strcat('A END  : ',datestr(now,'yyyymmdd_HHMMSS'))
    % si no se especifica el umbral se utiliza el 90% del maximo como
    % umbral
    
    %Primero analizo rho negativos
    N = A(1:round(d),1:end);
    if nuh == 0
        nuh = max(max(N)) * 0.9;
    end
    
    n_idx = find( N >= nuh );
    [trash,sidx] = sort(-1 * N(n_idx));
    n_sidx = n_idx(sidx);
    [nr,nt] = ind2sub(size(N),n_sidx);
    
    
    P=A(round(d)+1:end,1:end);
    if puh == 0
        puh = max(max(P)) * 0.9;
    end
    
    
    p_idx = find( P >= puh);
    [trash,sidx] = sort(-1 * P(p_idx));
    p_sidx = p_idx(sidx);
    [pr,pt] = ind2sub(size(P),p_sidx);

    
%     %filtro
%     for i = 1:min(length(t),max_lines);
%         if  A(r(i),t(i)) > 0 
%             filtromaxl = zeros(min([r(i)+drho size(A,1)]) - max([r(i)-drho 1]) + 1,min([t(i)+dtheta size(A,2)]) - max([t(i)-dtheta 1])+1);
%             filtromaxl(r(i)-max([r(i)-drho 1])+1,t(i)-max([t(i)-dtheta 1])+1) = 1;
%             A(max([r(i)-drho 1]):min([r(i)+drho size(A,1)]),max([t(i)-dtheta 1]):min([t(i)+dtheta size(A,2)])) =  A(max([r(i)-drho 1]):min([r(i)+drho size(A,1)]),max([t(i)-dtheta 1]):min([t(i)+dtheta size(A,2)]))  .* filtromaxl;
%         end
%     end
    

    lc=sum(N(n_idx) > 0) + sum(N(n_idx) > 0) ;
    
    nidx=find( N(n_sidx) > 0);
    pidx=find( P(p_sidx) > 0);
    nc=min(sum(N(n_idx) > 0),max_lines/2);
    pc=min(sum(P(p_idx) > 0),max_lines/2);
    
    lines=zeros(nc+pc,3);
    lines(1:nc,1)=round(nr(nidx(1:nc))-d);
    lines(nc+1:nc+pc,1)=round(pr(pidx(1:pc)));
    
    lines(1:nc,2)=delta*(nt(nidx(1:nc))-1);
    lines(nc+1:nc+pc,2)=delta*(pt(pidx(1:pc))-1);
    
    lines(1:nc,3)=N(n_sidx(nidx(1:nc)));
    lines(nc+1:nc+pc,3)=P(p_sidx(pidx(1:pc)));

end

