function [ output_file ] = procesar_camino( path,pidiv,delta_t,delta_r,max_lines,min_frame,max_frame,retry_max,desc)
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
%success frame_id rho1 theta1 votes1 delta_rho1 delta_theta1 rho2 theta2 votes2 delta_rho2 delta_theta2 line_count msum x y umin umax luh ruh retry_count ming1 ming2 maxg md1 md2 found_count_l found_l found_count_r found_r ll rl llbis rlbis mingbis maxgbis

%Variables Locales
%sc cuenta los frames en los que el algoritmo logra encontrar 2 rectas
% umin:     Umbral inferior para detector de bordes Canny
% umax:     Umbral superior para detector de bordes Canny
% uh:       Umbral para detector de linea de Hough
sc=0;
umin=0;
umax=0;
ruh=0;
luh=0;
tt=0;
%Creacion de archivos de salida
opath=strcat(path,'/output/',datestr(now,'yyyymmdd_HHMMSS'),'_',desc);
mkdir(opath);
output_file=strcat(opath,'/out_',int2str(umin),'_',int2str(umax),'_',int2str(pidiv),'_',int2str(delta_t),'_',int2str(delta_r),'_',desc,'.csv');
fp=fopen(output_file,'w+');
output_file=strcat(opath,'/selected_',int2str(umin),'_',int2str(umax),'_',int2str(pidiv),'_',int2str(delta_t),'_',int2str(delta_r),'_',desc,'.csv');
fps=fopen(output_file,'w+');
fprintf(fps,'success frame_id rho1 theta1 votes1 delta_rho1 delta_theta1 rho2 theta2 votes2 delta_rho2 delta_theta2 line_count msum x y umin umax luh ruh retry_count ming1 ming2 maxg md1 md2 found_count_l found_l found_count_r found_r ll rl llbis rlbis mingbis maxgbis\n');
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
        t1=now;
        [ l_lines,r_lines,ll,rl,lc,msum,x,y,umin,umax,luh,ruh,ming1,ming2,maxg,md1,md2,found_count_l,found_l,found_count_r ,found_r,llbis,rlbis,mingbis,maxgbis  ]  = procesar_frame( im,0,0,pi/pidiv,0,0,delta_t,delta_r,max_lines, s_lines);
        tt= tt + (now - t1);
        sl=size(l_lines,1)+size(r_lines,1);
        %Si no se encontraron las lineas, bajo umbrales para que se utilice
        %la media del frame
        rcount=rcount+1;
        if(  (rl == -1 || ll == -1  ) && rcount < retry_max  )
            umin=0; 
            umax=0;
            ruh=0;
            luh=0;
        else
             %Guardo Salida
            if( rl ~= -1 && ll ~= -1 )

                success = 1;
                %formato archivo
                %success frame_id rho1 theta1 votes1 rho2 theta2 votes2 lc msum x y 
                fprintf(fps,'1 %d %f %f %d %f %f ',i,l_lines(ll,1),l_lines(ll,2),l_lines(ll,3),abs(l_lines(ll,1)-s_lines(2,1)),abs(l_lines(ll,2)-s_lines(2,2)));
                fprintf(fps,'%f %f %d %f %f %d %f %d %d %f %f %f %f %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n',r_lines(rl,1),r_lines(rl,2),r_lines(rl,3),abs(r_lines(rl,1)-s_lines(1,1)),abs(r_lines(rl,2)-s_lines(1,2)),lc,msum,round(x),round(y),umin,umax,luh,ruh,rcount,round(ming1),round(ming2),round(maxg),round(md1),round(md2),found_count_l,found_l,found_count_r ,found_r,ll,rl,llbis,rlbis,round(mingbis),round(maxgbis));
                sim=ones(size(im));
                sim = repmat(im,[1 1 3]);
                sim = cat(3,im,im,im);
                sim(:,:,1) = draw_line(sim(:,:,1),r_lines(rl,1),r_lines(rl,2),255);
                sim(:,:,2) = draw_line(sim(:,:,2),l_lines(ll,1),l_lines(ll,2),255);
                fname = strcat(opath,'/frame_',int2str(i),'.png');
                imwrite(sim,fname);
                sim = repmat(im,[1 1 3]);
                sim = cat(3,im,im,im);
                sim(:,:,1) = draw_line(sim(:,:,1),r_lines(rlbis,1),r_lines(rlbis,2),255);
                sim(:,:,2) = draw_line(sim(:,:,2),l_lines(llbis,1),l_lines(llbis,2),255);
                fname = strcat(opath,'/frame_',int2str(i),'_bis.png');
                imwrite(sim,fname);
                
                sc=sc+1;
                s_lines(1,:) = r_lines(rl,:);
                s_lines(2,:) = l_lines(ll,:);
                ruh=0.9*s_lines(1,3);
                luh=0.9*s_lines(2,3);
            else
                fprintf(fps,'0 %d %f %f %d ',i,0,0,0);
                fprintf(fps,'%f %f %d %d %f %d %d %f %f %f %f %d %d\n',0,0,0,lc,msum,0,0,umin,umax,luh,ruh,rcount,round(ming));
            end

            rgbim = repmat(im,[1 1 3]);
            rgbim = cat(3,im,im,im);
            lines = l_lines;
            for j = 1:min(max_lines,size(lines,1))
                rgbim(:,:,mod(j,3)+1) = draw_line(rgbim(:,:,mod(j,3)+1),lines(j,1),lines(j,2),255);
                fprintf(fp,'%d %f %f %d\n',i,lines(j,1),lines(j,2),lines(j,3));
            end
            lines = r_lines;
            for j = 1:min(max_lines,size(lines,1))
                rgbim(:,:,mod(j,3)+1) = draw_line(rgbim(:,:,mod(j,3)+1),lines(j,1),lines(j,2),255);
                fprintf(fp,'%d %f %f %d\n',i,lines(j,1),lines(j,2),lines(j,3));
            end
            fname = strcat(opath,'/al_frame_',int2str(i),'.png');
            imwrite(rgbim,fname);
        end
        
    end
end
fclose(fp);
fclose(fps);
max_frame,datestr(now-ts,'HH:MM:SS')

end

