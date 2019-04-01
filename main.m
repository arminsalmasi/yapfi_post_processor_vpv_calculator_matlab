clc
close all 
clear variables
%[work_path]=get_path()
[work_path] = 'X:\Co_1_LPM_CCoW-liq-mc';
%work_path = 'C:\Users\armin\Documents\Pycharmprojects\workDIR\Co_Grad_1_LPM_CCoW-liq-mc';
[profile_fname]=read_profile(work_path);
load(profile_fname,'MOLE_FRACTIONS', 'NUMBER_OF_ELEMENTS', ...
                   'NUMBER_OF_PHASES', 'TIME', ...
                   'FINITE_VOLUME_CENTROID_COORDINATES', ...
                   'PHASE_NAMES', 'ELEMENT_NEMAES');
POLY3PATH ='C:\Users\armin\Documents\Pycharmprojects\POLY3-GES\3.POLY3';    %thermodynamics and kinetics (TCFE9, AIMD) W Ti N C Co (liquid, fcc_a1#2, Mc_shp)  
NPT = [1 101325 1723.15];                                                   %number of moles of the system ; % Ambient pressure % simulation temperature in kelvin                                                   
subIdx = [2 3];                                                            %index of substitutial atoms
FVCC = (FINITE_VOLUME_CENTROID_COORDINATES)';
clear FINITE_VOLUME_CENTROID_COORDINATES


 figure
 hold on 
 k=1;
for NTS = [1  size(TIME,1)]%size(TIME,1)%([100]%[1 2 50 100]%1:2:100;% 10 20 100 500  800 999]
    NTS
    TIME(NTS);
    [N,NPh,NPM,VPVTC,MD,MU] = extract_timestep_NVM(work_path,NPT,POLY3PATH,NTS);       %nts for now, other timesteps can be used                                                                                                       % results from the nts time step is used for initialization
    [U, UPh] = u_calc(N,NPh,subIdx);
    VPVU = vpvu_calc(N,NPh,subIdx);
    %figure; hold on
    %for PH =1: size(PHASE_NAMES,2)
        plot(FVCC, VPVU(1,:));
        lg{k} = num2str(TIME(NTS));
    %    lg{PH} = PHASE_NAMES{PH};
    %end
    %leg = legend(lg);
    title(['VPVU / time = ' num2str(TIME(NTS)) 'at timstep '  num2str(NTS)]);
    %lg{k} = char(num2str(TIME(NTS)));
    k=k+1;    
end
legend(lg)
