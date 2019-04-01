%% clear work environment 
function [work_path]=get_path()
    current_path= pwd ;  work_path = uigetdir(current_path);
    clear current_path
    disp(['work path is: ' work_path])
end

