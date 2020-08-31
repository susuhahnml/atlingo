:- not &tel
{ 
	(
			(
				(~ move(robot(N))) & 
				(>: ~ move(robot(N))) & 
				(>: >: ~ move(robot(N))) & 
				(>: >: >: ~ move(robot(N))) & 
				(>: >: >: >: ~ move(robot(N)))
			)
	 	>? 
			( looping_starts(robot(Last)))
	)
}
, robot(N), not N=Last, Last = #max{N : robot(N)}.
