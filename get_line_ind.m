function [ ind ] = get_line_ind( M,N,rho,theta )
%GET_LINE_IND  R,C ] = get_line_ind( M,N,rho,theta )
    if( theta ~= pi && theta ~= 0)
        C=[1:N];
        Ys =  round(rho/sin(theta) - C .* cos(theta)/sin(theta));
        Ys = Ys .* (Ys>0) .* (Ys <= M);
        idx=find(Ys~=0);
        ind=sub2ind(M,N,
    %else %Lineas Verticales
    %    if( rho > 0 && rho <= N)
    %       C=ones
    %    end
    end


end

