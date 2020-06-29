% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example where a happens in the next step and b eventually
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% :- not &tel{>a & (>? b)}.

:- not &tel{>? (move(right) & > move(left))}.


% gringo examples/temporal_constraints/tel_simple.lp formula_to_automaton/tel/theory.lp --output=reify > output_reified_formulas/tel/robot_moves.lp