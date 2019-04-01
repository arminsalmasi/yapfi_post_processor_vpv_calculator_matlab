function [U,U_ph_nrm_sum_N_sb_ph] = u_calc(N,NPh,idx_subt) 
%% conventions:
    %_sum means sum
    %_sb means substitutinals
    %_sy means system
    %_ph means phase
    %_nrm means normalized to
    U = 0*N;
    U_ph_nrm_sum_N_sb_ph = NPh*0;
    sum_N_sb_ph_gp = idx_subt*0;
    for gd =1: size(N,2)
        U(:,gd) = N(:,gd) ./ sum(N(idx_subt,gd));
        sum_N_sb_ph_gp(:) = sum(NPh(:,idx_subt,gd));
        U_ph_nrm_sum_N_sb_ph(:,:,gd)= NPh(:,:,gd)./sum_N_sb_ph_gp(:);
        %U_ph_nrm_s_sb_sy(:,:,gd)= NiPh(:,:,gd)./sum(N(nsubt,gd));
    end
end
