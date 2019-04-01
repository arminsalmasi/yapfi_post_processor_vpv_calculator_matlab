function [vpv_ph] = vpvu_calc(N,NPh,idx_subt) 
%% conventions:
    %_s means sum
    %_sb means substitutinals
    %_sy means system
    %_ph means phase
    %_nrm means normalized to
    sum_N_sb_ph_gp = idx_subt*0;
    vpv_ph = zeros(size(NPh,1),size(NPh,3));
    for gd =1: size(N,2)
        N_ph_s_sb_gp(:) = sum(NPh(:,idx_subt,gd));
        vpv_ph(:,gd) = N_ph_s_sb_gp / sum(N(idx_subt,gd));
    end
end