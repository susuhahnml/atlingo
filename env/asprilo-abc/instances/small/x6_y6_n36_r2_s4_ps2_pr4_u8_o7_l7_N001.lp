%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% = Command-line Arguments =================================
% -x 6 -y 6 -s 4 -p 2 -r 2 -P 4 -u 8 -o 7 -d env/asprilo-abc/instances -H --spr 2
%
% = Instance Statistics ====================================
% Grid Size X:                      6
% Grid Size Y:                      6
% Number of Nodes:                  36
% Number of Highway Nodes:          26
% Number of Robots:                 2
% Number of Shelves:                4
% Number of Picking Stations:       2
% Number of Products:               4
% Number of Product Units in Total: 8
% Number of Orders:                 7
% Number of Orders Lines:           7
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#program base.

% init
init(object(highway,1),value(at,(1,1))).
init(object(highway,3),value(at,(3,1))).
init(object(highway,5),value(at,(5,1))).
init(object(highway,6),value(at,(6,1))).
init(object(highway,7),value(at,(1,2))).
init(object(highway,8),value(at,(2,2))).
init(object(highway,9),value(at,(3,2))).
init(object(highway,10),value(at,(4,2))).
init(object(highway,11),value(at,(5,2))).
init(object(highway,12),value(at,(6,2))).
init(object(highway,13),value(at,(1,3))).
init(object(highway,16),value(at,(4,3))).
init(object(highway,18),value(at,(6,3))).
init(object(highway,19),value(at,(1,4))).
init(object(highway,22),value(at,(4,4))).
init(object(highway,24),value(at,(6,4))).
init(object(highway,25),value(at,(1,5))).
init(object(highway,26),value(at,(2,5))).
init(object(highway,27),value(at,(3,5))).
init(object(highway,28),value(at,(4,5))).
init(object(highway,29),value(at,(5,5))).
init(object(highway,30),value(at,(6,5))).
init(object(highway,33),value(at,(3,6))).
init(object(highway,34),value(at,(4,6))).
init(object(highway,35),value(at,(5,6))).
init(object(highway,36),value(at,(6,6))).
init(object(node,1),value(at,(1,1))).
init(object(node,2),value(at,(2,1))).
init(object(node,3),value(at,(3,1))).
init(object(node,4),value(at,(4,1))).
init(object(node,5),value(at,(5,1))).
init(object(node,6),value(at,(6,1))).
init(object(node,7),value(at,(1,2))).
init(object(node,8),value(at,(2,2))).
init(object(node,9),value(at,(3,2))).
init(object(node,10),value(at,(4,2))).
init(object(node,11),value(at,(5,2))).
init(object(node,12),value(at,(6,2))).
init(object(node,13),value(at,(1,3))).
init(object(node,14),value(at,(2,3))).
init(object(node,15),value(at,(3,3))).
init(object(node,16),value(at,(4,3))).
init(object(node,17),value(at,(5,3))).
init(object(node,18),value(at,(6,3))).
init(object(node,19),value(at,(1,4))).
init(object(node,20),value(at,(2,4))).
init(object(node,21),value(at,(3,4))).
init(object(node,22),value(at,(4,4))).
init(object(node,23),value(at,(5,4))).
init(object(node,24),value(at,(6,4))).
init(object(node,25),value(at,(1,5))).
init(object(node,26),value(at,(2,5))).
init(object(node,27),value(at,(3,5))).
init(object(node,28),value(at,(4,5))).
init(object(node,29),value(at,(5,5))).
init(object(node,30),value(at,(6,5))).
init(object(node,31),value(at,(1,6))).
init(object(node,32),value(at,(2,6))).
init(object(node,33),value(at,(3,6))).
init(object(node,34),value(at,(4,6))).
init(object(node,35),value(at,(5,6))).
init(object(node,36),value(at,(6,6))).
init(object(order,1),value(line,(3,1))).
init(object(order,1),value(pickingStation,1)).
init(object(order,2),value(line,(4,1))).
init(object(order,2),value(pickingStation,1)).
init(object(order,3),value(line,(1,1))).
init(object(order,3),value(pickingStation,1)).
init(object(order,4),value(line,(2,2))).
init(object(order,4),value(pickingStation,1)).
init(object(order,5),value(line,(1,1))).
init(object(order,5),value(pickingStation,1)).
init(object(order,6),value(line,(4,1))).
init(object(order,6),value(pickingStation,1)).
init(object(order,7),value(line,(3,1))).
init(object(order,7),value(pickingStation,1)).
init(object(pickingStation,1),value(at,(2,1))).
init(object(pickingStation,2),value(at,(4,1))).
init(object(product,1),value(on,(3,1))).
init(object(product,1),value(on,(4,1))).
init(object(product,2),value(on,(2,1))).
init(object(product,2),value(on,(3,1))).
init(object(product,3),value(on,(1,1))).
init(object(product,3),value(on,(2,1))).
init(object(product,4),value(on,(1,1))).
init(object(product,4),value(on,(3,1))).
init(object(robot,1),value(at,(1,6))).
init(object(robot,2),value(at,(2,6))).
init(object(shelf,1),value(at,(2,3))).
init(object(shelf,2),value(at,(2,4))).
init(object(shelf,3),value(at,(3,4))).
init(object(shelf,4),value(at,(5,4))).
