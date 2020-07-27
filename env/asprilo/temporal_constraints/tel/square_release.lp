:- not &tel
{ 
	(
			(
				(~ move(robot(R2))) & 
				(~ > move(robot(R2))) & 
				(~ > > move(robot(R2))) & 
				(~ > > > move(robot(R2))) & 
				(~ > > > > move(robot(R2)))
			)
	 	>? 
			( looping_starts(robot(Last)))
	)
}
, robot(R2), not R2=Last, Right = (1,0), Left = (-1,0), Up = (0,-1), Down = (0,1), Last = #max{R : robot(R)}.

