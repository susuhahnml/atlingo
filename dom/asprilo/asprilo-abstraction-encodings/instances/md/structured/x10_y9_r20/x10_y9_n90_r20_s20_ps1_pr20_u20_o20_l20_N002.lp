%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% M-domain instance converted to Md with:
%   - conversion encoding: /home/phil/dev/asprilo/suite/misc/convert-m-to-md.lp
%   - input instance: ./md/structured/x10_y9_r20/x10_y9_n90_r20_s20_ps1_pr20_u20_o20_l20_N002.lp
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% = Command-line Arguments =================================
% -x 10 -y 9 -X 2 -Y 2 -p 1 -r 20 -s 20 -P 20 -u 20 -o 20 --ol 1 --pus 1 -H -N 5 --imp -d x10_y9_r20
%
% = Instance Statistics ====================================
% Grid Size X:                      10
% Grid Size Y:                      9
% Number of Nodes:                  90
% Number of Highway Nodes:          9
% Number of Robots:                 20
% Number of Shelves:                20
% Number of Picking Stations:       1
% Number of Products:               20
% Number of Product Units in Total: 20
% Number of Orders:                 20
% Number of Orders Lines:           20
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#program base.

% init
init(object(highway,1),value(at,(1,1))).
init(object(highway,2),value(at,(1,2))).
init(object(highway,3),value(at,(1,3))).
init(object(highway,4),value(at,(1,4))).
init(object(highway,5),value(at,(1,5))).
init(object(highway,6),value(at,(1,6))).
init(object(highway,7),value(at,(1,7))).
init(object(highway,10),value(at,(2,1))).
init(object(highway,11),value(at,(2,2))).
init(object(highway,14),value(at,(2,5))).
init(object(highway,19),value(at,(3,1))).
init(object(highway,20),value(at,(3,2))).
init(object(highway,23),value(at,(3,5))).
init(object(highway,28),value(at,(4,1))).
init(object(highway,29),value(at,(4,2))).
init(object(highway,30),value(at,(4,3))).
init(object(highway,31),value(at,(4,4))).
init(object(highway,32),value(at,(4,5))).
init(object(highway,33),value(at,(4,6))).
init(object(highway,34),value(at,(4,7))).
init(object(highway,38),value(at,(5,2))).
init(object(highway,41),value(at,(5,5))).
init(object(highway,46),value(at,(6,1))).
init(object(highway,47),value(at,(6,2))).
init(object(highway,50),value(at,(6,5))).
init(object(highway,55),value(at,(7,1))).
init(object(highway,56),value(at,(7,2))).
init(object(highway,57),value(at,(7,3))).
init(object(highway,58),value(at,(7,4))).
init(object(highway,59),value(at,(7,5))).
init(object(highway,60),value(at,(7,6))).
init(object(highway,61),value(at,(7,7))).
init(object(highway,64),value(at,(8,1))).
init(object(highway,65),value(at,(8,2))).
init(object(highway,68),value(at,(8,5))).
init(object(highway,73),value(at,(9,1))).
init(object(highway,74),value(at,(9,2))).
init(object(highway,77),value(at,(9,5))).
init(object(highway,82),value(at,(10,1))).
init(object(highway,83),value(at,(10,2))).
init(object(highway,84),value(at,(10,3))).
init(object(highway,85),value(at,(10,4))).
init(object(highway,86),value(at,(10,5))).
init(object(highway,87),value(at,(10,6))).
init(object(highway,88),value(at,(10,7))).
init(object(node,1),value(at,(1,1))).
init(object(node,2),value(at,(1,2))).
init(object(node,3),value(at,(1,3))).
init(object(node,4),value(at,(1,4))).
init(object(node,5),value(at,(1,5))).
init(object(node,6),value(at,(1,6))).
init(object(node,7),value(at,(1,7))).
init(object(node,8),value(at,(1,8))).
init(object(node,9),value(at,(1,9))).
init(object(node,10),value(at,(2,1))).
init(object(node,11),value(at,(2,2))).
init(object(node,12),value(at,(2,3))).
init(object(node,13),value(at,(2,4))).
init(object(node,14),value(at,(2,5))).
init(object(node,15),value(at,(2,6))).
init(object(node,16),value(at,(2,7))).
init(object(node,17),value(at,(2,8))).
init(object(node,18),value(at,(2,9))).
init(object(node,19),value(at,(3,1))).
init(object(node,20),value(at,(3,2))).
init(object(node,21),value(at,(3,3))).
init(object(node,22),value(at,(3,4))).
init(object(node,23),value(at,(3,5))).
init(object(node,24),value(at,(3,6))).
init(object(node,25),value(at,(3,7))).
init(object(node,26),value(at,(3,8))).
init(object(node,27),value(at,(3,9))).
init(object(node,28),value(at,(4,1))).
init(object(node,29),value(at,(4,2))).
init(object(node,30),value(at,(4,3))).
init(object(node,31),value(at,(4,4))).
init(object(node,32),value(at,(4,5))).
init(object(node,33),value(at,(4,6))).
init(object(node,34),value(at,(4,7))).
init(object(node,35),value(at,(4,8))).
init(object(node,36),value(at,(4,9))).
init(object(node,37),value(at,(5,1))).
init(object(node,38),value(at,(5,2))).
init(object(node,39),value(at,(5,3))).
init(object(node,40),value(at,(5,4))).
init(object(node,41),value(at,(5,5))).
init(object(node,42),value(at,(5,6))).
init(object(node,43),value(at,(5,7))).
init(object(node,44),value(at,(5,8))).
init(object(node,45),value(at,(5,9))).
init(object(node,46),value(at,(6,1))).
init(object(node,47),value(at,(6,2))).
init(object(node,48),value(at,(6,3))).
init(object(node,49),value(at,(6,4))).
init(object(node,50),value(at,(6,5))).
init(object(node,51),value(at,(6,6))).
init(object(node,52),value(at,(6,7))).
init(object(node,53),value(at,(6,8))).
init(object(node,54),value(at,(6,9))).
init(object(node,55),value(at,(7,1))).
init(object(node,56),value(at,(7,2))).
init(object(node,57),value(at,(7,3))).
init(object(node,58),value(at,(7,4))).
init(object(node,59),value(at,(7,5))).
init(object(node,60),value(at,(7,6))).
init(object(node,61),value(at,(7,7))).
init(object(node,62),value(at,(7,8))).
init(object(node,63),value(at,(7,9))).
init(object(node,64),value(at,(8,1))).
init(object(node,65),value(at,(8,2))).
init(object(node,66),value(at,(8,3))).
init(object(node,67),value(at,(8,4))).
init(object(node,68),value(at,(8,5))).
init(object(node,69),value(at,(8,6))).
init(object(node,70),value(at,(8,7))).
init(object(node,71),value(at,(8,8))).
init(object(node,72),value(at,(8,9))).
init(object(node,73),value(at,(9,1))).
init(object(node,74),value(at,(9,2))).
init(object(node,75),value(at,(9,3))).
init(object(node,76),value(at,(9,4))).
init(object(node,77),value(at,(9,5))).
init(object(node,78),value(at,(9,6))).
init(object(node,79),value(at,(9,7))).
init(object(node,80),value(at,(9,8))).
init(object(node,81),value(at,(9,9))).
init(object(node,82),value(at,(10,1))).
init(object(node,83),value(at,(10,2))).
init(object(node,84),value(at,(10,3))).
init(object(node,85),value(at,(10,4))).
init(object(node,86),value(at,(10,5))).
init(object(node,87),value(at,(10,6))).
init(object(node,88),value(at,(10,7))).
init(object(node,89),value(at,(10,8))).
init(object(node,90),value(at,(10,9))).
init(object(robot,1),value(at,(10,9))).
init(object(robot,2),value(at,(10,8))).
init(object(robot,3),value(at,(9,9))).
init(object(robot,4),value(at,(9,8))).
init(object(robot,5),value(at,(8,9))).
init(object(robot,6),value(at,(8,8))).
init(object(robot,7),value(at,(7,9))).
init(object(robot,8),value(at,(7,8))).
init(object(robot,9),value(at,(6,9))).
init(object(robot,10),value(at,(6,8))).
init(object(robot,11),value(at,(5,9))).
init(object(robot,12),value(at,(5,8))).
init(object(robot,13),value(at,(4,9))).
init(object(robot,14),value(at,(4,8))).
init(object(robot,15),value(at,(3,9))).
init(object(robot,16),value(at,(3,8))).
init(object(robot,17),value(at,(2,9))).
init(object(robot,18),value(at,(2,8))).
init(object(robot,19),value(at,(1,9))).
init(object(robot,20),value(at,(1,8))).
init(object(destination,1),value(at,(6,3))).
init(object(destination,2),value(at,(9,4))).
init(object(destination,3),value(at,(6,4))).
init(object(destination,4),value(at,(9,3))).
init(object(destination,5),value(at,(3,4))).
init(object(destination,6),value(at,(5,4))).
init(object(destination,7),value(at,(6,6))).
init(object(destination,8),value(at,(2,4))).
init(object(destination,9),value(at,(9,7))).
init(object(destination,10),value(at,(8,4))).
init(object(destination,11),value(at,(2,6))).
init(object(destination,12),value(at,(6,7))).
init(object(destination,13),value(at,(9,6))).
init(object(destination,14),value(at,(5,3))).
init(object(destination,15),value(at,(5,7))).
init(object(destination,16),value(at,(8,7))).
init(object(destination,17),value(at,(3,7))).
init(object(destination,18),value(at,(5,6))).
init(object(destination,19),value(at,(8,3))).
init(object(destination,20),value(at,(2,3))).
