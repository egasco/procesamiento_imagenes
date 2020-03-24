function [ output_file ] = procesar_camino( path,pidiv,max_lines,min_frame,max_frame,retry_max,desc)
%PROCESAR_CAMINO [ output_file ] = procesar_camino( path,pidiv,delta_t,delta_r,max_lines,max_frame,retry_max)
% Procesa frames de video previamente exportados a imagenes png grayscale.
% Pre: Las imagenes de entrada tienen que tener nombre de la forma
% frame_x.png, donde x es un numero entero
% Pos: El algoritmo intenta detectar 2 lineas que delimitan un camino u
% andarivel recto utlizando una combinacion de detecores de bordes y
% el detector de lineas de Hough.De encontrarlo el algoritmo devuelve las 
% coordenadas de dichas rectas.
%
% Entrada:
% path:     Path donde se encuentran las imagenes de los frames.
% pidiv:    Especifica discretizacion de theta . Delta theta = pi/pidiv.
% delta_t:  De ser mayor que cero espcifica a Hough que solo devuelva la
%           maxima recta encontrada para un delta theta. Permite quedarse con maximo
%           local para rectas de angulos muy parecidos
% delta_r:  Idem anterior pero para parametro rho.
% max_lines:Permite limitar la cantidad de lineas devueltas por el
%           detector Hough.
% retry_max:De ser mayor a 0, especifica al algoritmo cuantas veces puede
%           iterar por un mismo frame a fin de refinar umbrales.( Opcion
%           util con umin = umax = uh = 0, para el cual el algoritmo se intenta
%           seleccionar umbrales optimos para el camino en cuestion)
% Salida:
% output_file: Nombre de archivo de salida
% Formato archivo de salida(CSV)
%success frame_id rho1 theta1 votes1 delta_rho1 delta_theta1 rho2 theta2 votes2 delta_rho2 delta_theta2 line_count msum x y umin umax luh ruh retry_count

%Variables Locales
% umin:     Umbral inferior para detector de bordes Canny
% umax:     Umbral superior para detector de bordes Canny
% uh:       Umbral para detector de linea de Hough
umin=0;
umax=0;
ruh=0;
luh=0;
%Creacion de archivo de salida
opath=strcat(path,'/output/',datestr(now,'yyyymmdd_HHMMSS'),'_',desc);
mkdir(opath);
output_file=strcat(opath,'/selected_',int2str(pidiv),'_',desc,'.csv');
fps=fopen(output_file,'w+');
fprintf(fps,'success frame_id rho1 theta1 votes1 delta_rho1 delta_theta1 rho2 theta2 votes2 delta_rho2 delta_theta2 line_count msum x y umin umax luh ruh retry_count ming1 ming2 maxg md1 md2 found_count_l found_l found_count_r found_r ll rl llbis rlbis mingbis maxgbis\n');
%Borra sin(theta) y cos(theta) de corrida anterior
clear s;
clear c;
ts=now;
s_lines = zeros(2,3);
for i=min_frame:max_frame
    fname = strcat(path,'/frame_',int2str(i),'.png');
    im = imread(fname);
    rcount=0;
    sl=0;
    success = 0;
    while rcount < retry_max  && success == 0;
        % parametros umin,umax,luh y ruh fijos en 0, no se guardan
        % umbrales y desactiva la logica de reintento
        [ l_lines,r_lines,ll,rl,lc,msum,x,y,umin,umax,luh,ruh ]  = procesar_frame( im,0,0,pi/pidiv,0,0,max_lines);
        %Si no se encontraron las lineas, bajo umbrales para que se utilice
        %la media del frame
        rcount=rcount+1;
        if(  (rl == -1 || ll == -1  ) && rcount < retry_max  )
            umin=0; 
            umax=0;
            ruh=0;
            luh=0;
        else
             %Si procesar frame encontre 2 lineas que delimiten el camino,guardo Salida
            if( rl ~= -1 && ll ~= -1 )
                success = 1;
                fprintf(fps,'1 %d %f %f %d %f %f ',i,l_lines(ll,1),l_lines(ll,2),l_lines(ll,3),abs(l_lines(ll,1)-s_lines(2,1)),abs(l_lines(ll,2)-s_lines(2,2)));
                fprintf(fps,'%f %f %d %f %f %d %f %d %d %f %f %f %f %d\n',r_lines(rl,1),r_lines(rl,2),r_lines(rl,3),abs(r_lines(rl,1)-s_lines(1,1)),abs(r_lines(rl,2)-s_lines(1,2)),lc,msum,round(x),round(y),umin,umax,luh,ruh,rcount);
                sim = cat(3,im,im,im);
                sim(:,:,1) = draw_line(sim(:,:,1),r_lines(rl,1),r_lines(rl,2),255);
                sim(:,:,2) = draw_line(sim(:,:,2),l_lines(ll,1),l_lines(ll,2),255);
                fname = strcat(opath,'/frame_',int2str(i),'.png');
                imwrite(sim,fname);           
            end
        end      
    end
end
fclose(fps);
datestr(now-ts,'HH:MM:SS')

end

