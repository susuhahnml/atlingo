
legal(robot(R),(X,Y)) :- position((X,Y)), position(robot(R),(X',Y'),0), position(destination(R),(X'',Y'')),
	              	 X=X'..X'',Y=Y'..Y''.
legal(robot(R),(X,Y)) :- position((X,Y)), position(robot(R),(X',Y'),0), position(destination(R),(X'',Y'')),
	              	 X=X'..X'',Y=Y''..Y'.
legal(robot(R),(X,Y)) :- position((X,Y)), position(robot(R),(X',Y'),0), position(destination(R),(X'',Y'')),
	              	 X=X''..X',Y=Y'..Y''.
legal(robot(R),(X,Y)) :- position((X,Y)), position(robot(R),(X',Y'),0), position(destination(R),(X'',Y'')),
	              	 X=X''..X',Y=Y''..Y'.


:- position(R,C,T), not legal(R,C), isRobot(R).
