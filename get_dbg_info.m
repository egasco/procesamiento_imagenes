function [ dbginfo,lc,umin,umax,luh,ruh ] = get_dbg_info( path,equalize,suavizado,direccion,umin,umax,pidiv,luh,ruh,delta_t,delta_r,max_lines,mode)
%GET_DBG_INFO  [ dbginfo,lc,umin,umax,luh,ruh ] = get_dbg_info( path,equalize,suavizado,direccion,umin,umax,pidiv,luh,ruh,delta_t,delta_r,max_lines,mode)
%   dbginfo.of : frame original
%   dbginfo.ef : frame con histograma ecualizado
%   dbginfo.lines: matriz lcx3 = [ rho theta votos ]
%   dbginfo.dir: direccion de gradiente de ef
%   dbginfo.grad: modulo gradiente ef 
%   dbginfo.borders: bordes ef
    
    of = imread(path);
    [M,N] = size(of);
    
    %ef = ecualizar_histograma(of);
    if equalize == 1
        ef=histeq(of);
    else
        ef =of;
    end
    
    %ef=of;
    if ( mode == 1 )
        [ nimx,nimy,ograd,rnim,grad ,dir,edge1,edge2,nim,umin,umax] = ed_canny(ef, suavizado, direccion,'sobel',1,umin,umax ); 
    %strcat('Hough Start',datestr(now,'yyyymmdd_HHMMSS'))
    %[ lines,A,borders,lc,umin,umax,nuh,puh ] = ld_hough( im, 'canny',1,umin,umax,delta,nuh,puh,delta_t,delta_r,max_lines);
    [ l_lines,r_lines,A,lc,luh ,ruh] = ld_hough2( nim, 0,pi/pidiv,luh,ruh,delta_t,delta_r,max_lines);
    else
        [ lines,dir,grad,A,nim,lc,umin,umax,ruh,luh ] = ld_hough( ef, 'canny',suavizado,direccion,umin,umax,pi/pidiv,ruh,luh,delta_t,delta_r,max_lines);
        l_lines = lines;
        r_lines = lines;
    end
    %lc = size(lines,1);
%     dlines=zeros(lc,M);
%     for i = 1:lc
%         rho=lines(i,1);
%         th=lines(i,2);
% 
%         if( th ~= (pi/2) )
%             Xs = round(-(sin(th)/cos(th)) .* [1:M]+ rho/cos(th));
%             Xs = Xs .* (Xs>0);
%             for j=1:M
%                 if Xs(j) ~= 0 && Xs(j) < N
%                     dlines(i,j) = rad2deg(dir(j,Xs(j)));
%                 end
%             end
%         else %Lineas Horizontales
%             if( rho > 0 && rho < N)
%                 dlines(i,:)=rad2deg(dir(rho,:));
%             end
%         end
%     end
        
    dbginfo = struct('of',of,'ef',ef,'l_lines',l_lines,'r_lines',r_lines,'dir',dir,'grad',grad,'borders',nim);
end

