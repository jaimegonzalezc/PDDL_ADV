(define (problem p-cooperation)
	(:domain cooperation)
	(:objects
		X6_Y10 X10_Y2 X5_Y9 X16_Y13 - Coord
		Leader - UGV
		Follower0 - UAV
		Base1 Base2 - BaseStation
		P_0 - Pan
		T_0 - Tilt)
	(:init
		(= (total-distance Leader) 0)
		(= (total-distance Follower0) 0)
		(= (energy Leader) 200)
		(= (energy Follower0) 200)
		(= (distance X6_Y10 X10_Y2) 9)
		(= (distance X6_Y10 X5_Y9) 1)
		(= (distance X6_Y10 X16_Y13) 10)
		(= (distance X10_Y2 X6_Y10) 9)
		(= (distance X10_Y2 X5_Y9) 9)
		(= (distance X10_Y2 X6_Y10) 9)
		(= (distance X10_Y2 X16_Y13) 13)
		(= (distance X5_Y9 X6_Y10) 1)
		(= (distance X5_Y9 X10_Y2) 9)
		(= (distance X5_Y9 X16_Y13) 12)
		(= (distance X16_Y13 X6_Y10) 10)
		(= (distance X16_Y13 X10_Y2) 13)
		(= (distance X16_Y13 X5_Y9) 12)
		(= (distance X16_Y13 X16_Y13) 0)
		(= (distance X5_Y9 X5_Y9) 0)
		(= (distance X10_Y2 X10_Y2) 0)
		(= (distance X6_Y10 X6_Y10) 0)
		(= (pan-distance P_0 P_0) 0)
		(= (tilt-distance T_0 T_0)0)
		(at Leader X6_Y10)
		(at Base1 X6_Y10)
		(my-base Leader Base1)
		(at Follower0 X10_Y2)
		(at Base2 X10_Y2)
		(my-base Follower0 Base2)
		(N0-enabled Leader)
		(N0-enabled Follower0)
		(camera-Pan Leader P_0)
		(camera-Tilt Leader T_0)
		(camera-Pan Follower0 P_0)
		(camera-Tilt Follower0 T_0)
		(docked Leader)
		(docked Follower0))	
		
	(:goal
		(and
			(image-taken P_0 T_0 X5_Y9 Leader)
			(image-taken P_0 T_0 X16_Y13 Follower0)
			(image-sent P_0 T_0 X5_Y9 Leader)
			(image-sent P_0 T_0 X16_Y13 Follower0)
			)))
	
	(:constraints (and
		(preference UAV-no-base(always (undocked Follower0)))
		(preference UGV-no-base(sometime (undocked Leader)))))
			
	(:metric minimize(+(- 10000 (energy Leader))(- 10000 (energy Follower0)) (*(is-violated UAV-no-base)2) (*(is-violated UGV-no-base) 3))))
