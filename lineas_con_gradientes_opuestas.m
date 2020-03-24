function [ ll,rl,msum,x,y ] = lineas_con_gradientes_opuestas(M,N,l_lines,r_lines,dir)
%LINEAS_CON_GRADIENTES_OPUESTAS Slecciona las 2 lineas que minimizen la
%suma de direccion de gradiente
% Entrada:
% M:        Cantidad de Filas
% N:        Cantidad de Columnas
% l_lines:  Vector con listas seleccionadas de la mitad izquierda de la imagen
% r_lines:  Vector con listas seleccionadas de la mitad derecha de la imagen
% dir:      Matriz con direccion de gradiente en cada punto
% Salida:
% ll:       Indice de linea izquierda seleccionada. De no seleccionar -1.
% rl:       Indice de linea derecha seleccionada. De no seleccionar -1.
% msum:     suma de direccion de gradientes de lineas seleccionadas
% x:        Posicion de x donde intersectan las rectas seleccionadas
% y:        Posicion de y donde intersectan las rectas seleccionadas
    lc = size(l_lines,1);
    rc = size(r_lines,1);
    m_lines=zeros(lc+rc,M);
    g_lines=zeros(lc+rc,2);
    g_lines(:,1) = inf;
    g_lines(:,2) = 0;
    msum=inf;
    ll=-1;
    rl=-1;
    x=0;
    y=0;
    lines=l_lines;
    for i = 1:lc
        rho=lines(i,1);
        theta=lines(i,2);

        if( theta ~= (pi/2) )
            Xs = round(-(sin(theta)/cos(theta)) .* [1:M]+ rho/cos(theta));
            Xs = Xs .* (Xs>0) .* (Xs<N);
            for j=1:M
                if Xs(j) ~= 0 && Xs(j) < N && ~isnan(dir(j,Xs(j)))
                    m_lines(i,j) = dir(j,Xs(j));
                end
            end
         else %Lineas Horizontales, no nos interesan ponemos valores inf
             if( rho > 0 && rho < M)
                 m_lines(i,:)=inf;
             end
        end
    end
    lines=r_lines;
    for i = 1:rc
        rho=lines(i,1);
        theta=lines(i,2);

        if( theta ~= (pi/2) )
            Xs = round(-(sin(theta)/cos(theta)) .* [1:M]+ rho/cos(theta));
            Xs = Xs .* (Xs>0) .* (Xs<N);
            for j=1:M
                if Xs(j) ~= 0 && Xs(j) < N
                    m_lines(lc+i,j) = dir(j,Xs(j));
                end
            end
%         else %Lineas Horizontales
%             if( rho > 0 && rho < M)
%                 m_lines(i,:)=inf;
%             end
        end
    end

    md=inf;
    for u = 1:lc
        for v = 1:rc
            A=[cos(l_lines(u,2)) sin(l_lines(u,2));cos(r_lines(v,2)) sin(r_lines(v,2))];
            B = [l_lines(u,1); r_lines(v,1)];
            X = linsolve(A,B);
            x=round(X(1));
            y=round(X(2));
            if( x <0 || x > N || y < 0 || y > M )
                x=0;y=0;
            end
            max_y=min([sum(m_lines(u,max([1 y]):end) ~= 0) sum(m_lines(lc+v,max([1 y]):end) ~= 0)])+y-1;
            tsum=sum(abs(m_lines(u,max([1 y]):max_y)+m_lines(lc+v,max([1 y]):max_y)));
            if( y < M &&  tsum < msum)
                msum = tsum;
                ll = u;
                rl = v;
            end               
        end
    end  
end

