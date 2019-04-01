function [N,NPh,NPM,VPV,MD,MU] = extract_timestep_NVM(wpath,NPT,P3PATH,NTS)
    %% this oly works for 1D
    load([wpath '\profile.mat'],...
        'ELEMENT_NEMAES', 'PHASE_NAMES',...
        'NUMBER_OF_GRID_POINTS', 'MOLE_FRACTIONS')
    NUMBER_OF_ELEMENTS = size(ELEMENT_NEMAES,2);
    NUMBER_OF_PHASES   = size(PHASE_NAMES,2);
    %% tc calc initialization
    tc_init_root;
    tc_read_poly3_file(P3PATH);
    %[nph_nw, ph_name_nw] = tc_list_phase;
    %[ncomp_nw, comp_name_nw] = tc_list_component;
    tctoolbox('tc_set_condition', 'n', NPT(1));
    tctoolbox('tc_set_condition', 'p', NPT(2));
    tctoolbox('tc_set_condition', 't', NPT(3));
    MF = (MOLE_FRACTIONS((NTS-1)*NUMBER_OF_ELEMENTS*NUMBER_OF_GRID_POINTS+1: NTS*NUMBER_OF_ELEMENTS*NUMBER_OF_GRID_POINTS))';
    N   = zeros(NUMBER_OF_ELEMENTS, NUMBER_OF_GRID_POINTS);
    MU  = N;
    NPM = zeros(NUMBER_OF_PHASES, NUMBER_OF_GRID_POINTS);
    VPV = NPM;
    NPH = zeros(NUMBER_OF_PHASES, NUMBER_OF_ELEMENTS,NUMBER_OF_GRID_POINTS);
    MD  = NPH;
    for GD = 1: NUMBER_OF_GRID_POINTS
        %% set condition and calculate equilibrium
        F=1; %all elemnts of the MF vector NEL*NGD
        for j = ((GD-1)*NUMBER_OF_ELEMENTS+1): (GD*NUMBER_OF_ELEMENTS-1) %(1:nel-1) Gridwiz
            tctoolbox('tc_set_condition',char(['X(' ELEMENT_NEMAES{F} ')']), MF(j));
            F = F+1;
        end
        tc_compute_equilibrium;
        %% read DATA
        for EL = 1: NUMBER_OF_ELEMENTS
            N(EL,GD) = tc_get_value(char(['N('  char(ELEMENT_NEMAES(EL)) ')']));
            MU(EL,GD) = tc_get_value(char(['MU(' char(ELEMENT_NEMAES(EL)) ')']));
            %X_init(EL,GD) = tc_get_value(char(['X(' char(ELEMENT_NEMAES(EL)) ')']));
        end
        for PH = 1: NUMBER_OF_PHASES
            NPM(PH,GD) = tc_get_value(char(['npm(' char(PHASE_NAMES{PH}) ')']));
            VPV(PH,GD) = tc_get_value(char(['vpv(' char(PHASE_NAMES{PH}) ')']));
            for EL = 1 : NUMBER_OF_ELEMENTS
                %XiPh_init(PH,EL,GD) = tc_get_value(char(['X(' char( PHASE_NAMES{PH}) ',' char(ELEMENT_NEMAES(EL)) ')']));
                NPh(PH,EL,GD) = tc_get_value(char(['N(' char( PHASE_NAMES{PH}) ',' char(ELEMENT_NEMAES(EL)) ')']));
                MD(PH,EL,GD)  = tc_get_value(char(['M(' char( PHASE_NAMES{PH}) ',' char(ELEMENT_NEMAES(EL)) ')']));
            end
        end
    end
    %% Exit message
    %clearvars -except N_init X_init XiPh_init  NiPh_init NPM_init VPVTC_init
    %init_fname = [work_path '\init.mat'];
    %save(init_fname);
end