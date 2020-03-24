function [ im ] = draw_line( im,rho,theta,value )
%DRAW_LINE Draws line parametrized by theta and rho function [ im ] = draw_line( im,rho,theta,value )
    [M,N] = size(im);
    im = im;
%     if( theta ~= 0 )
%         y0 = round(round(-(cos(theta)/sin(theta)) .* [1:N] + rho/sin(theta)));
%         y0 = y0 .* (y0>0);
%         for j=1:N
%             if y0(j) ~= 0 && y0(j) < M
%                 im(y0(j),j)=value;
%             end
%         end
%     else
%         if( rho > 0 && rho < N)
%             im(1:end,rho)=value;
%         end
%     end
    if( theta ~= pi && theta ~= 0)
        Ys =  round(rho/sin(theta) - [1:N] .* cos(theta)/sin(theta));
        Ys = Ys .* (Ys>0);
        for j=1:N
            if Ys(j) > 0 && Ys(j) < M
                im(Ys(j),j) = value;
            end
        end
    else %Lineas Verticales
        if( rho > 0 && rho < N)
            im(1:end,rho)=value;
        end
    end

    if( theta ~= (pi/2) )
        Xs = round(-(sin(theta)/cos(theta)) .* [1:M]+ rho/cos(theta));
        Xs = Xs .* (Xs>0) .* (Xs<N);
        for j=1:M
            if Xs(j) ~= 0 && Xs(j) < N 
                im(j,Xs(j)) = value;
            end
        end
end

