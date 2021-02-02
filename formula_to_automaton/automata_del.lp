% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Automata:
% %     Generates the translation of the automata
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

#include "del/states.lp".

% %------------------ Delta function ------------------------
% %
% %       delta(S,B): The delta transition from state S is the
% %                    positive boolean formula B
#include "del/delta.lp".

% %------------------ Include mapping to visualize ids and use in trace  map ----------------

#include "id_map.lp".

% #include "del/reachable.lp".

% #show nnf/2.
#show state/1.
#show delta/3.
#show initial_state/1.
#show prop_id/1.


