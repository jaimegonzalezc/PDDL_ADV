(define (domain cooperation)
(:requirements :typing :durative-actions :fluents :equality);:constraints :preferences)
(:types UGV UAV - Vehicle
	Vehicle Basestation - object 
	NavMode Pan Tilt X Y)
(:predicates
	(docked ?v - Vehicle)
	(undocked ?v - Vehicle)
	(my-base ?v - Vehicle ?bs - BaseStation)
	(image-taken ?P - Pan ?T - Tilt ?x - X ?y - Y)
	(image-not-sent ?p - Pan ?t - Tilt ?x - X ?y - Y)
	(image-sent ?p - Pan ?t - Tilt ?x - X ?y - Y)
	(camera-Pan ?v - Vehicle ?P - Pan)
	(camera-Tilt ?v - Vehicle ?T - Tilt)
	(at-x ?o - object ?x - X)
	(at-y ?o - object ?y - Y)
	(N0-enabled ?v - Vehicle) ;slow mode
	(N1-enabled ?v - Vehicle) ;fast mode
	(distance-calculated ?xIni ?xFin - X ?yIni ?yFin - Y);Nos indica si la distancia enter los puntos pasados por parametro esta calculada o no
	(rotation-calculated ?pIni ?pFin - Pan ?tIni ?tFin - Tilt))
(:functions
	(distance ?xIni ?xFin - X ?yIni ?yFin - Y)
	(rotation ?pIni ?pFin - Pan ?tIni ?tFin - Tilt)
	(total-distance ?v - Vehicle)
	(energy ?v - Vehicle)
	(pan-number ?p - Pan)
	(tilt-number ?p - Tilt)
	(x-number ?x - X)
	(y-number ?y - Y))

(:durative-action dock
	:parameters (?v - Vehicle ?bs - BaseStation ?x - X ?y - Y)
	:duration(= ?duration 1)
	:condition(and
		(at start 
			(and
				(undocked ?v)
				(> (energy ?v) 1)
			)
		)
		(over all 
			(and
				(at-x ?bs ?x)
				(at-y ?bs ?y)
				(at-x ?v ?x)
				(at-y ?v ?y)
				(my-base ?v ?bs)
			)
		)
	)
	:effect(at end 
			(and
				(not (undocked ?v))
				(docked ?v)
				(decrease (energy ?v) 1)
			)
	)
)

(:durative-action undock
	:parameters(?v - Vehicle ?bs - BaseStation ?x - X ?y - Y)
	:duration(= ?duration 1)
	:condition(and
		(at start
			(and 
				(docked ?v)
				(> (energy ?v) 1)
			)
		)
		(over all 
			(and
				(at-x ?bs ?x)
				(at-y ?bs ?y)
				(at-x ?v ?x)
				(at-y ?v ?y)
			)
		)
	)
	:effect(at end 
			(and
				(not (docked ?v))
				(undocked ?v)
				(decrease (energy ?v) 1)
			)
	)
)

(:durative-action take-photo
	:parameters (?v - Vehicle ?p - Pan ?t - Tilt ?x - X ?y - Y)
	:duration (= ?duration 1);el hecho de tomar la foto siempre dura lo mismo 
	:condition (and
		(over all 
			(and 
				(camera-Pan ?v ?p)
				(camera-Tilt ?v ?t)
				(at-x ?v ?x) 
				(at-y ?v ?y) 
				(undocked ?v)
			)
		)
		(at start 
			(and
				;(not (image-taken ?p ?t ?x ?y))
				(> (energy ?v) 1)
			)
		)
	)
	:effect (at end 
			(and 
				(image-taken ?p ?t ?x ?y)
				(image-not-sent ?p ?t ?x ?y)
				(decrease (energy ?v) 1)
			)
	)
)

(:durative-action orient-camera
	:parameters (?v - Vehicle ?p ?pIni - Pan ?t ?tIni - Tilt)
	:duration (= ?duration 1);(/ (+ (* (- (pan-number ?p) (pan-number ?pIni)) 2) (* (- (tilt-number ?t) (tilt-number ?tIni))2)) 2))
	:condition (and
		(at start 
			(and
				(camera-Tilt ?v ?tIni)
				(camera-Pan ?v ?pIni)
			)
		)
			;(> (/ (+ (* (- (pan-number ?p) (pan-number ?pIni)) 2) (* (- (tilt-number ?t) (tilt-number ?tIni))2)) 2) 0) ;Controlar que la duracion no sea 0
			;(> (energy ?v) (/ (+ (* (- (pan-number ?p) (pan-number ?pIni)) 2) (* (- (tilt-number ?t) (tilt-number ?tIni))2)) 2))))
		(over all 
			(undocked ?v)
		)
	)	
	:effect(at end 
			(and 
				(camera-Tilt ?v ?t)
				(camera-Pan ?v ?p)
				(not (camera-Tilt ?v ?tIni))
				(not (camera-Pan ?v ?pIni))
		)
	)
)
			;(decrease (energy ?v) (/ (+ (* (- (pan-number ?p) (pan-number ?pIni)) 2) (* (- (tilt-number ?t) (tilt-number ?tIni))2)) 2)))))
		
(:durative-action move-N0
	:parameters(?v - Vehicle ?xStart ?xDest - X ?yStart ?yDest - Y)
	:duration (= ?duration (distance ?xStart ?xDest ?yStart ?yDest))
	:condition(and
		(at start 
			(and
				(at-x ?v ?xStart)
				(at-y ?v ?yStart)
				(> (distance ?xStart ?xDest ?yStart ?yDest) 0);Controlo que la duracion no sea 0 (que la casilla inicio y la final sean diferentes)
				(> (energy ?v) (distance ?xStart ?xDest ?yStart ?yDest))
			)
		)
		(over all 
			(and 
				(N0-enabled ?v)
				(undocked ?v)
				(distance-calculated ?xStart ?xDest ?yStart ?yDest)
			)
		)
	)
	:effect(at end
			(and
				(not (at-x ?v ?xStart))
				(not (at-y ?v ?yStart))
				(at-x ?v ?xDest)
				(at-y ?v ?yDest)
				(decrease (energy ?v) (distance ?xStart ?xDest ?yStart ?yDest))
				(increase (total-distance ?v) (distance ?xStart ?xDest ?yStart ?yDest))
			)
	)
)

(:durative-action move-N1
	:parameters(?v - Vehicle ?xStart ?xDest - X ?yStart ?yDest - Y)
	:duration (= ?duration (/ (distance ?xStart ?xDest ?yStart ?yDest)2))
	:condition(and
		(at start 
			(and
				(at-x ?v ?xStart)
				(at-y ?v ?yStart)
				(> (/ (distance ?xStart ?xDest ?yStart ?yDest)2) 0);Esto verifica que no nos movamos a la misma casilla que nos encontremos
				(> (energy ?v) (* (distance ?xStart ?xDest ?yStart ?yDest) 2))
			)
		) ;Como va el doble de rapido que en N0, logicamente gasta el doble de energia
		(over all 
			(and 
				(N1-enabled ?v)
				(undocked ?v)
				(distance-calculated ?xStart ?xDest ?yStart ?yDest)
			)
		)
	)
	:effect(at end
			(and
				(not (at-x ?v ?xStart))
				(not (at-y ?v ?yStart))
				(at-x ?v ?xDest)
				(at-y ?v ?yDest)
				(increase (total-distance ?v) (distance ?xStart ?xDest ?yStart ?yDest))
				(decrease (energy ?v) (* (distance ?xStart ?xDest ?yStart ?yDest)2))
			)
	)
)
			

(:durative-action send-image
	:parameters(?v - Vehicle ?p - Pan ?t - Tilt ?x - X ?y - Y)
	:duration(= ?duration 1)
	:condition(and
		(at start 
			(and
				(image-not-sent ?p ?t ?x ?y)
				(> (energy ?v) 1)
			)
		)
		(over all 
			(image-taken ?p ?t ?x ?y )
		)
	)
	:effect(at end (and
			(not (image-not-sent ?p ?t ?x ?y))
			(image-sent ?p ?t ?x ?y)
			(decrease (energy ?v) 1))))

(:durative-action change-to-N0
	:parameters(?v - Vehicle)
	:duration(= ?duration 1)
	:condition(at start(and
			(N1-enabled ?v)
			(> (energy ?v) 1)))
	:effect(at end 
			(and
				(N0-enabled ?v)
				(not (N1-enabled ?v))
				(decrease (energy ?v) 1)
			)
	)
)

(:durative-action recharge
	:parameters(?v - Vehicle)
	:duration(= ?duration (* (- 10000 (energy ?v)) 2))
	:condition(over all 
			(docked ?v)
	)
	:effect(at end 
			(increase (energy ?v) (/ (* (- 10000 (energy ?v)) 2) 2)
		)
	)
)

(:durative-action change-to-N1
	:parameters(?v - Vehicle)
	:duration(= ?duration 1)
	:condition(at start 
			(and
				(N0-enabled ?v)
			)
	)
	:effect(at end 
			(and 
				(not (N0-enabled ?v))
				(N1-enabled ?v)
				(decrease (energy ?v) 1)
			)
	)
)

(:durative-action calculate-distance
	:parameters(?xIni ?xFin - X ?yIni ?yFin - Y)
	:duration(= ?duration 1)
	:condition (and
		(at start 
			(= (distance ?xIni ?xFin ?yIni ?yFin) 0)
		)
		(over all 
			(> (+(* (- (x-number ?xFin) (x-number ?xIni)) 2) (* (- (y-number ?yFin) (y-number ?yIni))2))0)
		)
	)
	:effect(at end 
			(and
				;(decrease (distance ?xIni ?xFin ?yIni ?yFin) (distance ?xIni ?xFin ?yIni ?yFin));Para hacerlo 0
				(increase (distance ?xIni ?xFin ?yIni ?yFin) (+(* (- (x-number ?xFin) (x-number ?xIni)) 2) (* (- (y-number ?yFin) (y-number ?yIni))2)))
				(distance-calculated ?xIni ?xFin ?yIni ?yFin)
		)
	)
)

(:durative-action zero-distance
	:parameters(?xIni ?xFin - X ?yIni ?yFin - Y)
	:duration(= ?duration 1)
	:condition(at start 
			(< (distance ?xIni ?xFin ?yIni ?yFin) 0)
	)
	:effect(at end 
		(decrease (distance ?xIni ?xFin ?yIni ?yFin) (distance ?xIni ?xFin ?yIni ?yFin))
	)
)
)
