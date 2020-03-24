function [sim] = draw_lines( im , l1,l2,value)
%DRAW_LINES Summary of this function goes here
%   Detailed explanation goes here

        sim=ones(size(im));
        sim = repmat(im,[1 1 3]);
        sim = cat(3,im,im,im);
        sim(:,:,1) = draw_line(sim(:,:,1),l1(1),l1(2),value);
        sim(:,:,2) = draw_line(sim(:,:,2),l2(1),l2(2),value);
        
end

