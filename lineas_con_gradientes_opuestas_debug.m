function [ ll,rl,msum,x,y,ming1,ming2,maxg,md1,md2,llbis,rlbis,mingbis,maxgbis ] = lineas_con_gradientes_opuestas(M,N,l_lines,r_lines,dir,grad )
%LINEAS_CON_GRADIENTES_OPUESTAS Summary of this function goes here
    lc = size(l_lines,1);
    rc = size(r_lines,1);
    m_lines=zeros(lc+rc,M);
    g_lines=zeros(lc+rc,2);
    g_lines(:,1) = inf;
    g_lines(:,2) = 0;
    msum=inf;
    ll=-1;
    rl=-1;
    ming1=-1;
    ming2=-1;
    maxg=-1;
    llbis=-1;
    rlbis=-1;
    mingbis=-1;
    maxgbis=-1;
    md1=-1;
    md2=-1;
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
                    if( grad(j,Xs(j)) > 0 && grad(j,Xs(j)) < g_lines(i,1) )
                        g_lines(i,1)  = grad(j,Xs(j));
                    end
                    if( grad(j,Xs(j)) > g_lines(i,2) )
                        g_lines(i,2)  = grad(j,Xs(j));
                    end
                end
            end
%         else %Lineas Horizontales
%             if( rho > 0 && rho < M)
%                 m_lines(i,:)=inf;
%             end
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
                    if( grad(j,Xs(j)) > 0 && grad(j,Xs(j)) < g_lines(lc+i,1) )
                        g_lines(lc+i,1)  = grad(j,Xs(j));
                    end
                    if( grad(j,Xs(j)) > g_lines(lc+i,2) )
                        g_lines(lc+i,2)  = grad(j,Xs(j));
                    end
                end
            end
%         else %Lineas Horizontales
%             if( rho > 0 && rho < M)
%                 m_lines(i,:)=inf;
%             end
        end
    end
%     if( theta ~= pi && theta ~= 0)
%         Ys =  round(rho/sin(theta) - [1:N] .* cos(theta)/sin(theta));
%         Ys = Ys .* (Ys>0);
%         for j=1:N
%             if Ys(j) > 0 && Ys(j) < M
%                 m_lines(i,Ys(j)) = dir(Ys(j),j);
%             end
%         end
%     else %Lineas Verticales
%         if( rho > 0 && rho < N)
%             m_lines(i,:)=dir(:,rho)';
%         end
%     end
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
            md1 = mean(rad2deg(m_lines(u,max([1 y]):max_y)));
            md2 = mean(rad2deg(m_lines(lc+v,max([1 y]):max_y)));
            tmd = abs(md1+md2);
            if( y < M && tmd < md)
                md=tmd;
                llbis = u;
                rlbis =v;
                mingbis = min([g_lines(llbis,1) g_lines(lc+rlbis,1)]);
                maxgbis = max([g_lines(llbis,2) g_lines(lc+rlbis,2)]);
            end
            
            %strcat('u=',int2str(u),' v=',int2str(v),' tsum=',int2str(tsum),' points=',int2str(max_y-max([1 y])))
            if( y < M &&  tsum < msum)
                msum = tsum;
                ll = u;
                rl = v;
            end               
        end
    end
    if( ll ~= -1 && rl ~= -1 )
        ming1 = min(g_lines(ll,1));
        ming2 = g_lines(lc+rl,1);
        maxg = max([g_lines(ll,2) g_lines(lc+rl,2)]);
        md1 = mean(rad2deg(m_lines(ll,max([1 y]):max_y)));
        md2 = mean(rad2deg(m_lines(lc+rl,max([1 y]):max_y)));
    end
  
end

