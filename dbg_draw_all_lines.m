
function [sim] = dbg_draw_all_lines( dbg_info )
%DBG_DRAW_LINES Summary of this function goes here
%   Detailed explanation goes here

        sim=ones(size(dbg_info.of));
        sim = repmat(dbg_info.of,[1 1 3]);
        sim = cat(3,dbg_info.of,dbg_info.of,dbg_info.of);
        lines = dbg_info.l_lines;
        for j = 1:size(lines,1)
            sim(:,:,mod(j,3)+1) = draw_line(sim(:,:,mod(j,3)+1),lines(j,1),lines(j,2),255);
        end
        lines = dbg_info.r_lines;
        for j = 1:size(lines,1)
            sim(:,:,mod(j,3)+1) = draw_line(sim(:,:,mod(j,3)+1),lines(j,1),lines(j,2),255);
        end

end

