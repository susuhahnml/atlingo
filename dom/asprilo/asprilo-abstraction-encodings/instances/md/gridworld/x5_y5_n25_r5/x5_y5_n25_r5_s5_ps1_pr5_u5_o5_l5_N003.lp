%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% M-domain instance converted to Md with:
%   - conversion encoding: /home/phil/dev/asprilo/suite/misc/convert-m-to-md.lp
%   - input instance: ./md/gridworld/x5_y5_n25_r5/x5_y5_n25_r5_s5_ps1_pr5_u5_o5_l5_N003.lp
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% = Command-line Arguments =================================
% --cs --ns --ao 1 --imp -x 5 -y 5 -p 1 -s 5 -r 5 -P 5 -u 5 -o 5 --ol 1 -D --pus 1 -n 25 -d x5_y5_n25_r5 -N 5
%
% = Instance Statistics ====================================
% Grid Size X:                      5
% Grid Size Y:                      5
% Number of Nodes:                  25
% Number of Highway Nodes:          0
% Number of Robots:                 5
% Number of Shelves:                5
% Number of Picking Stations:       1
% Number of Products:               5
% Number of Product Units in Total: 5
% Number of Orders:                 5
% Number of Orders Lines:           5
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#program base.

% init
init(object(node,1),value(at,(1,1))).
init(object(node,2),value(at,(1,2))).
init(object(node,3),value(at,(1,3))).
init(object(node,4),value(at,(1,4))).
init(object(node,5),value(at,(1,5))).
init(object(node,6),value(at,(2,1))).
init(object(node,7),value(at,(2,2))).
init(object(node,8),value(at,(2,3))).
init(object(node,9),value(at,(2,4))).
init(object(node,10),value(at,(2,5))).
init(object(node,11),value(at,(3,1))).
init(object(node,12),value(at,(3,2))).
init(object(node,13),value(at,(3,3))).
init(object(node,14),value(at,(3,4))).
init(object(node,15),value(at,(3,5))).
init(object(node,16),value(at,(4,1))).
init(object(node,17),value(at,(4,2))).
init(object(node,18),value(at,(4,3))).
init(object(node,19),value(at,(4,4))).
init(object(node,20),value(at,(4,5))).
init(object(node,21),value(at,(5,1))).
init(object(node,22),value(at,(5,2))).
init(object(node,23),value(at,(5,3))).
init(object(node,24),value(at,(5,4))).
init(object(node,25),value(at,(5,5))).
init(object(robot,1),value(at,(4,2))).
init(object(robot,2),value(at,(3,5))).
init(object(robot,3),value(at,(3,2))).
init(object(robot,4),value(at,(2,2))).
init(object(robot,5),value(at,(2,1))).
init(object(destination,1),value(at,(4,4))).
init(object(destination,2),value(at,(2,3))).
init(object(destination,3),value(at,(5,2))).
init(object(destination,4),value(at,(1,5))).
init(object(destination,5),value(at,(3,1))).
