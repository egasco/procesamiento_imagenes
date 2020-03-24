function [ val ] = values_on_line( m,rho,theta,min_y )
%VALUES_ON_LINE Summary of this function goes here
%   devuelve los valores de de la matriz en las coordenadas de la recta 
%  rho = x cos(theta) + y sen(theta)

    [M,N] = size(m);
    
    val = zeros(1,M);
    if( theta ~= pi && theta ~= 0)
        Xs = round(-(sin(theta)/cos(theta)) .* [1:M]+ rho/cos(theta));
        Xs = Xs .* (Xs>0) .* (Xs<N) ;
        Xs
        max([1 min_y])
        min([min_y M])
        Xs(max([1 min_y]):M)=0;
        idx =find(Xs > 0);
        for i=1:length(idx)
                val(idx(i)) = m(idx(i),Xs(idx(i)));
        end
   end
    %else %Lineas Verticales
        %if( rho > 0 && rho < N)
         %   im(1:end,rho)=value;
        %end


end

