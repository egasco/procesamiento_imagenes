function [ l_lines,r_lines,ll,rl,lc,msum,x,y,umin,umax,luh,ruh ]  = procesar_frame( im,umin,umax,delta,luh,ruh,max_lines)
%PROCESAR_FRAME [ lines,mu,mv ]  = procesar_frame( im,umin,umax,delta,uh,delta_t,delta_r,max_lines  )
%Entrada
% im:       Frame a procesar
% umin:     Umbral inferior para detector de bordes Canny, de ser 0 se usa  2 * mean(reshape(grad,1,M1*N1));
% umax:     Umbral superior para detector de bordes Canny, de ser 0 se usa 3/2 * umin
% delta:    Especifica discretizacion de theta . 
% luh:      umbral para lineas izquierdas en hough
% ruh:      umbral para lineas derechas en hough
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
% l_lines:  Vector con listas seleccionadas de la mitad izquierda de la imagen
% r_lines:  Vector con listas seleccionadas de la mitad derecha de la imagen
% ll:       Indice de linea izquierda seleccionada
% rl:       Indice de linea derecha seleccionada
% lc:       Rectas detectadas por hough
% msum:     Suma minima de direcciones de gradiente para el frame
% x:        Posicion de x donde intersectan las rectas seleccionadas
% y:        Posicion de y donde intersectan las rectas seleccionadas
% umin:     Umbral umin utilizado para procesar frame
% umax:     Umbral umax utilizado para procesar frame
% luh:      Umbral para lineas izquierdas en hough
% ruh:      Umbral para lineas derechas en hough



    ll=-1;
    rl=-1;
    msum=inf;
    x=0;
    y=0;
    
    [M,N] = size(im);
    %Ecualizacion de Histograma - se utliza version de matlab por mejor
    %preformance
    im=histeq(im);
    %im=ecualizar_histograma(im);

    %Edge detector Canny
    [ nimx,nimy,ograd,rnim,grad ,dir,edge1,edge2,nim,umin,umax] = ed_canny(im, 2, 1,'sobel',1,umin,umax ); 
    %Transformada de Hough
    [ l_lines,r_lines,lc,luh,ruh ] = ld_hough2( nim, 0,delta,luh,ruh,max_lines);
  

    %Seleccion de 2 Lineas que minimicen suma de gradientes
    if( lc >=2 )
        [ ll,rl,msum,x,y] = lineas_con_gradientes_opuestas(M,N,l_lines,r_lines,dir);
    end


end

