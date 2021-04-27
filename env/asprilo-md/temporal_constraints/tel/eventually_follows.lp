% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example where robots must eventually follow each other robot 
% % for two steps
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- not &tel{ >? (following(robot(R),robot(R')) & > following(robot(R),robot(R')) )}, robot(R),robot(R'),R!=R'.