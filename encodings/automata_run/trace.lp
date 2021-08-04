% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Trace:
% %     Creates the last time step of the trace where nothing
% %     can hold after
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% %-------------------- "last" holds in last timestep ------------------------

#const horizon = 8. %Passed as a parameter
#const lambda = horizon+1. %Passed as a parameter

% Last holds in horizon
trace(ID,lambda-1):-prop(ID,"last").

% %-------------------- True holds in all time steps ------------------------
% trace(true,0..lambda-1). %Now in run

% %-------------------- Used to better visualize traces ------------------------
holds_map(T,MAP):- trace(ID,T), prop(ID,MAP).