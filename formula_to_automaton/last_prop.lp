% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Last prop:
% %     Crates proposition for last time_step
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


#const new_last_id = 99999.

% Define theory_string for last
theory_string(new_last_id+1,"last").
theory_function(new_last_id,new_last_id+1,-1).

last_id(ID):- theory_function(ID,ID_O,ID_T), theory_string(ID_O,"last").