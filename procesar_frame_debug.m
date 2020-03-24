function [ l_lines,r_lines,ll,rl,lc,msum,x,y,umin,umax,luh,ruh,ming1,ming2,maxg,md1,md2,found_count_l,found_l,found_count_r ,found_r,llbis,rlbis,mingbis,maxgbis   ]  = procesar_frame( im,umin,umax,delta,luh,ruh,delta_t,delta_r,max_lines,s_lines )
%PROCESAR_FRAME [ lines,mu,mv ]  = procesar_frame( im,umin,umax,delta,uh,delta_t,delta_r,max_lines  )
%Entrada
% im:       Frame a procesar
% umin:     Umbral inferior para detector de bordes Canny
% umax:     Umbral superior para detector de bordes Canny
% delta:    Especifica discretizacion de theta . 
% uh:       Umbral para detector de linea de Hough
% delta_t:  De ser mayor que cero espcifica a Hough que solo devuelva la
%           maxima recta encontrada para un delta theta. Permite quedarse con maximo
%           local para rectas de angulos muy parecidos
% delta_r:  Idem anterior pero para parametro rho.
% max_lines:Permite limitar la cantidad de lineas devueltas por el
%           detector Hough.
%
%
%
%
%
%Salida:
%
%
%
%
%
%
%

%   Detailed explanation goes here
    %strcat('HProcess Frame Start',datestr(now,'yyyymmdd_HHMMSS'))
    ll=-1;
    rl=-1;
    msum=inf;
    x=0;
    y=0;
    ming1=-1;
    ming2=-1;
    maxg=-1;
    md1=-1;
    md2=-1;
    
    [M,N] = size(im);
    %Ecualizacion de Histograma
    %im=ecualizar_histograma(im);
    im=histeq(im);
    %Edge detector
    [ nimx,nimy,ograd,rnim,grad ,dir,edge1,edge2,nim,umin,umax] = ed_canny(im, 2, 1,'sobel',1,umin,umax ); 
    %strcat('Hough Start',datestr(now,'yyyymmdd_HHMMSS'))
    %[ lines,A,borders,lc,umin,umax,nuh,puh ] = ld_hough( im, 'canny',1,umin,umax,delta,nuh,puh,delta_t,delta_r,max_lines);
    [ l_lines,r_lines,A,lc,luh,ruh ] = ld_hough2( nim, 0,delta,luh,ruh,delta_t,delta_r,max_lines);
%    lc=size(lines,1);
     %datestr(now,'yyyymmdd_HHMMSS')
     found=0;
     rho=s_lines(1,1);
     theta=s_lines(1,2);
     Xs = round(-(sin(theta)/cos(theta)) .* [1:M]+ rho/cos(theta));
     Xs = Xs .* (Xs>0) .* (Xs<N);
     idx =find(Xs > 0);
     found_count_l =  sum(grad(sub2ind(size(grad), idx,Xs(idx))) > umax );
     found_l = found_count_l > luh;
     rho=s_lines(2,1);
     theta=s_lines(2,2);
     Xs = round(-(sin(theta)/cos(theta)) .* [1:M]+ rho/cos(theta));
     Xs = Xs .* (Xs>0) .* (Xs<N);
     idx =find(Xs > 0);
     found_count_r =  sum(grad(sub2ind(size(grad), idx,Xs(idx))) > umax );
     found_r = found_count_r > ruh;

    %Seleccion de 2 Lineas que minimicen suma de gradientes
    if( lc >=2 )
        %strcat('Line Selection Start',datestr(now,'yyyymmdd_HHMMSS'))
        [ ll,rl,msum,x,y,ming1,ming2,maxg,md1,md2,llbis,rlbis,mingbis,maxgbis  ] = lineas_con_gradientes_opuestas(M,N,l_lines,r_lines,dir,grad .* not(nim));
        %datestr(now,'yyyymmdd_HHMMSS')
    end
    %strcat('HProcess Frame End',datestr(now,'yyyymmdd_HHMMSS'))
    %Aca puedo analizar hough y ver maxi


end

