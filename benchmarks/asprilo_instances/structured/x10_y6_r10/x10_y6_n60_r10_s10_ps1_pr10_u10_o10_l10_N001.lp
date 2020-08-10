%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% M-domain instance converted to Md with:
%   - conversion encoding: /home/phil/dev/asprilo/suite/misc/convert-m-to-md.lp
%   - input instance: ./md/structured/x10_y6_r10/x10_y6_n60_r10_s10_ps1_pr10_u10_o10_l10_N001.lp
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% = Command-line Arguments =================================
% -x 10 -y 6 -X 2 -Y 2 -p 1 -r 10 -s 10 -P 10 -u 10 -o 10 --ol 1 --pus 1 -H -N 5 --imp -d x10_y6_r10
%
% = Instance Statistics ====================================
% Grid Size X:                      10
% Grid Size Y:                      6
% Number of Nodes:                  60
% Number of Highway Nodes:          9
% Number of Robots:                 10
% Number of Shelves:                10
% Number of Picking Stations:       1
% Number of Products:               10
% Number of Product Units in Total: 10
% Number of Orders:                 10
% Number of Orders Lines:           10
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#program base.

% init
init(object(highway,1),value(at,(1,1))).
init(object(highway,2),value(at,(1,2))).
init(object(highway,3),value(at,(1,3))).
init(object(highway,4),value(at,(1,4))).
init(object(highway,5),value(at,(1,5))).
init(object(highway,7),value(at,(2,1))).
init(object(highway,8),value(at,(2,2))).
init(object(highway,11),value(at,(2,5))).
init(object(highway,13),value(at,(3,1))).
init(object(highway,14),value(at,(3,2))).
init(object(highway,17),value(at,(3,5))).
init(object(highway,19),value(at,(4,1))).
init(object(highway,20),value(at,(4,2))).
init(object(highway,21),value(at,(4,3))).
init(object(highway,22),value(at,(4,4))).
init(object(highway,23),value(at,(4,5))).
init(object(highway,26),value(at,(5,2))).
init(object(highway,29),value(at,(5,5))).
init(object(highway,31),value(at,(6,1))).
init(object(highway,32),value(at,(6,2))).
init(object(highway,35),value(at,(6,5))).
init(object(highway,37),value(at,(7,1))).
init(object(highway,38),value(at,(7,2))).
init(object(highway,39),value(at,(7,3))).
init(object(highway,40),value(at,(7,4))).
init(object(highway,41),value(at,(7,5))).
init(object(highway,43),value(at,(8,1))).
init(object(highway,44),value(at,(8,2))).
init(object(highway,47),value(at,(8,5))).
init(object(highway,49),value(at,(9,1))).
init(object(highway,50),value(at,(9,2))).
init(object(highway,53),value(at,(9,5))).
init(object(highway,55),value(at,(10,1))).
init(object(highway,56),value(at,(10,2))).
init(object(highway,57),value(at,(10,3))).
init(object(highway,58),value(at,(10,4))).
init(object(highway,59),value(at,(10,5))).
init(object(node,1),value(at,(1,1))).
init(object(node,2),value(at,(1,2))).
init(object(node,3),value(at,(1,3))).
init(object(node,4),value(at,(1,4))).
init(object(node,5),value(at,(1,5))).
init(object(node,6),value(at,(1,6))).
init(object(node,7),value(at,(2,1))).
init(object(node,8),value(at,(2,2))).
init(object(node,9),value(at,(2,3))).
init(object(node,10),value(at,(2,4))).
init(object(node,11),value(at,(2,5))).
init(object(node,12),value(at,(2,6))).
init(object(node,13),value(at,(3,1))).
init(object(node,14),value(at,(3,2))).
init(object(node,15),value(at,(3,3))).
init(object(node,16),value(at,(3,4))).
init(object(node,17),value(at,(3,5))).
init(object(node,18),value(at,(3,6))).
init(object(node,19),value(at,(4,1))).
init(object(node,20),value(at,(4,2))).
init(object(node,21),value(at,(4,3))).
init(object(node,22),value(at,(4,4))).
init(object(node,23),value(at,(4,5))).
init(object(node,24),value(at,(4,6))).
init(object(node,25),value(at,(5,1))).
init(object(node,26),value(at,(5,2))).
init(object(node,27),value(at,(5,3))).
init(object(node,28),value(at,(5,4))).
init(object(node,29),value(at,(5,5))).
init(object(node,30),value(at,(5,6))).
init(object(node,31),value(at,(6,1))).
init(object(node,32),value(at,(6,2))).
init(object(node,33),value(at,(6,3))).
init(object(node,34),value(at,(6,4))).
init(object(node,35),value(at,(6,5))).
init(object(node,36),value(at,(6,6))).
init(object(node,37),value(at,(7,1))).
init(object(node,38),value(at,(7,2))).
init(object(node,39),value(at,(7,3))).
init(object(node,40),value(at,(7,4))).
init(object(node,41),value(at,(7,5))).
init(object(node,42),value(at,(7,6))).
init(object(node,43),value(at,(8,1))).
init(object(node,44),value(at,(8,2))).
init(object(node,45),value(at,(8,3))).
init(object(node,46),value(at,(8,4))).
init(object(node,47),value(at,(8,5))).
init(object(node,48),value(at,(8,6))).
init(object(node,49),value(at,(9,1))).
init(object(node,50),value(at,(9,2))).
init(object(node,51),value(at,(9,3))).
init(object(node,52),value(at,(9,4))).
init(object(node,53),value(at,(9,5))).
init(object(node,54),value(at,(9,6))).
init(object(node,55),value(at,(10,1))).
init(object(node,56),value(at,(10,2))).
init(object(node,57),value(at,(10,3))).
init(object(node,58),value(at,(10,4))).
init(object(node,59),value(at,(10,5))).
init(object(node,60),value(at,(10,6))).
init(object(robot,1),value(at,(10,6))).
init(object(robot,2),value(at,(9,6))).
init(object(robot,3),value(at,(8,6))).
init(object(robot,4),value(at,(7,6))).
init(object(robot,5),value(at,(6,6))).
init(object(robot,6),value(at,(5,6))).
init(object(robot,7),value(at,(4,6))).
init(object(robot,8),value(at,(3,6))).
init(object(robot,9),value(at,(2,6))).
init(object(robot,10),value(at,(1,6))).
init(object(destination,1),value(at,(6,4))).
init(object(destination,2),value(at,(2,3))).
init(object(destination,3),value(at,(2,4))).
init(object(destination,4),value(at,(8,3))).
init(object(destination,5),value(at,(5,4))).
init(object(destination,6),value(at,(9,4))).
init(object(destination,7),value(at,(5,3))).
init(object(destination,8),value(at,(8,4))).
init(object(destination,9),value(at,(3,3))).
init(object(destination,10),value(at,(3,4))).
