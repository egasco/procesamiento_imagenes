function [sim] = draw_lines_bw( im , lines,value)
%DRAW_LINES Summary of this function goes here
%   Detailed explanation goes here

        sim =im;
        for i =1:size(lines,1)
            sim = draw_line(sim,lines(i,1),lines(i,2),value);
        end
        
end


