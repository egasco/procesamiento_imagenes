function [sim] = dbg_draw_lines( dbg_info , ll,rl)
%DBG_DRAW_LINES Summary of this function goes here
%   Detailed explanation goes here

        sim=ones(size(dbg_info.of));
        sim = repmat(dbg_info.of,[1 1 3]);
        sim = cat(3,dbg_info.of,dbg_info.of,dbg_info.of);
        sim(:,:,1) = draw_line(sim(:,:,1),dbg_info.l_lines(ll,1),dbg_info.l_lines(ll,2),255);
        sim(:,:,2) = draw_line(sim(:,:,2),dbg_info.r_lines(rl,1),dbg_info.r_lines(rl,2),255);

end

