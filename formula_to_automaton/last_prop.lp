% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Last prop:
% %     Crates proposition for last time_step
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

used_id(ID):-theory_string(ID,S),S!="last".
used_id(ID):-theory_function(ID,IDS,_),theory_string(IDS,S),S!="last".

last_id(MID+1):- #max{ID:used_id(ID)}=MID.

% Define theory_string for last
theory_string(ID,"last"):-last_id(ID).

#show last_id/1. %DONT REMOVE


