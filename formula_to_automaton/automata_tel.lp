% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Automata:
% %     Generates the translation of the automata
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %-------------------- Atomic propositions --------------------------
% %
% %       prop(ID,PROP): 
% %             - Where ID is the id of a proposition
% %             - Where PROP a visualization of the proposition

#include "prop.lp".

% %--------------------  States --------------------------
% %
% %       initial_state(ID): ID of the initial state
% %       state(ID,S): State with id ID 

#include "tel/states.lp".

% %------------------ Delta function ------------------------
% %
% %       delta(ID_S,(Case,Type,Prop)),ID_S'): The delta transition 
% %                 - From state with id ID_S 
% %                 - To state with id ID_S' 
% %                 - When all conditions (Type,Prop) hold for case Case

#include "tel/delta.lp".


% %------------------ Clean up ------------------------
#include "./clean.lp".


#show state/2.
#show delta/3.
#show initial_state/1.
#show prop/2.


