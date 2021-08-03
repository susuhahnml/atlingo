%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% M-domain instance converted to Md with:
%   - conversion encoding: /home/phil/dev/asprilo/suite/misc/convert-m-to-md.lp
%   - input instance: ./md/gridworld/x4_y4_n12_r4/x4_y4_n12_r4_s4_ps1_pr4_u4_o4_l4_N004.lp
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% = Command-line Arguments =================================
% --cs --ns --ao 1 --imp -x 4 -y 4 -p 1 -s 4 -r 4 -P 4 -u 4 -o 4 --ol 1 -D --pus 1 -n 12 -d x4_y4_n12_r4 -N 5
%
% = Instance Statistics ====================================
% Grid Size X:                      4
% Grid Size Y:                      4
% Number of Nodes:                  12
% Number of Highway Nodes:          0
% Number of Robots:                 4
% Number of Shelves:                4
% Number of Picking Stations:       1
% Number of Products:               4
% Number of Product Units in Total: 4
% Number of Orders:                 4
% Number of Orders Lines:           4
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#program base.

% init
init(object(node,1),value(at,(4,4))).
init(object(node,2),value(at,(1,3))).
init(object(node,3),value(at,(2,4))).
init(object(node,4),value(at,(1,2))).
init(object(node,5),value(at,(3,4))).
init(object(node,6),value(at,(4,3))).
init(object(node,7),value(at,(3,1))).
init(object(node,8),value(at,(1,1))).
init(object(node,9),value(at,(1,4))).
init(object(node,10),value(at,(2,2))).
init(object(node,11),value(at,(3,2))).
init(object(node,12),value(at,(4,1))).
init(object(robot,1),value(at,(4,1))).
init(object(robot,2),value(at,(3,2))).
init(object(robot,3),value(at,(2,2))).
init(object(robot,4),value(at,(4,4))).
init(object(destination,1),value(at,(2,4))).
init(object(destination,2),value(at,(3,1))).
init(object(destination,3),value(at,(1,1))).
init(object(destination,4),value(at,(4,3))).
