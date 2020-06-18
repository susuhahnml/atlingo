% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Automata:
% %     Generates the translation of the automata
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#const logic_type="del".
logic(logic_type).
% %-------------------- Define last --------------------------
% %
% %       last_id(ID): Where ID is the id of proposition last

#include "last_prop.lp".
% %-------------------- Atomic propositions --------------------------
% %
% %       prop_id(ID): Where ID is the id of a proposition

#include "propositional_atoms.lp".
% %--------------------  States --------------------------
% %
% %       initial_state(S): The initial state
% %       state(S): All states

#include "tel/states.lp".
% #include "del/states.lp".
% #include "del/states.lp":-logic("del"). ????????????????????????????

% %------------------ Delta function ------------------------
% %
% %       delta(S,B): The delta transition from state S is the
% %                    positive boolean formula B
#include "tel/delta.lp".
% #include "del/delta.lp".

% %------------------ Include mapping to visualize ids and use in trace  map ----------------

#include "id_map.lp".


#show state/1.
#show delta/2.
#show initial_state/1.
#show prop_id/1.

