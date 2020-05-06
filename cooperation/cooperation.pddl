(define (domain cooperation)
(:requirements :typing :durative-actions :fluents :equality :constraints :preferences)
(:types UGV UAV - Vehicle
	Vehicle Basestation - object 
	NavMode Pan Tilt Coord)
(:predicates
	(docked ?v - Vehicle)
	(undocked ?v - Vehicle)
	(my-base ?v - Vehicle ?bs - BaseStation)
	(image-taken ?P - Pan ?T - Tilt ?c - Coord ?v - Vehicle)
	(image-not-sent ?p - Pan ?t - Tilt ?c - Coord ?v - Vehicle)
	(image-sent ?p - Pan ?t - Tilt ?c - Coord ?v - Vehicle)
	(camera-Pan ?v - Vehicle ?P - Pan)
	(camera-Tilt ?v - Vehicle ?T - Tilt)
	(at ?o - object ?c - Coord)
	(N0-enabled ?v - Vehicle) ;slow mode
	(N1-enabled ?v - Vehicle)) ;fast mode
(:functions
	(total-distance ?v - Vehicle)
	(energy ?v - Vehicle)
	(distance ?cStart ?cDest - Coord)
	(pan-distance ?pStart ?pDest - Pan)
	(tilt-distance ?tStart ?tEnd - Tilt))

(:durative-action dock
	:parameters (?v - Vehicle ?bs - BaseStation ?c - Coord)
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
				(at ?bs ?c)
				(at ?v ?c)
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
	:parameters(?v - Vehicle ?bs - BaseStation ?c - Coord)
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
				(at ?bs ?c)
				(at ?v ?c)
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
	:parameters (?v - Vehicle ?p - Pan ?t - Tilt ?c - Coord)
	:duration (= ?duration 1);el hecho de tomar la foto siempre dura lo mismo 
	:condition (and
		(over all 
			(and 
				(camera-Pan ?v ?p)
				(camera-Tilt ?v ?t)
				(at ?v ?c)
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
				(image-taken ?p ?t ?c ?v)
				(image-not-sent ?p ?t ?c ?v)
				(decrease (energy ?v) 1)
			)
	)
)

(:durative-action orient-camera
	:parameters (?v - Vehicle ?p - Pan ?pIni - Pan ?t - Tilt ?tIni - Tilt)
	:duration (= ?duration (/ (+ (pan-distance ?pIni ?p) (tilt-distance ?tIni ?t)) 5))
	:condition (and
		(at start 
			(and
				(camera-Tilt ?v ?tIni)
				(camera-Pan ?v ?pIni)
				(> (/ (+ (pan-distance ?pIni ?p) (tilt-distance ?tIni ?t)) 5) 0) ;Se controla que la duracion no sea cero
				(> (energy ?v) (/ (+ (pan-distance ?pIni ?p) (tilt-distance ?tIni ?t)) 5))
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
				(decrease (energy ?v) (/ (+ (pan-distance ?pIni ?p) (tilt-distance ?tIni ?t)) 5))
		)
	)
)
		
(:durative-action move-N0
	:parameters(?v - Vehicle ?cStart ?cDest - Coord)
	:duration (= ?duration (distance ?cStart ?cDest))
	:condition(and
		(at start 
			(and
				(at ?v ?cStart)
				(> (distance ?cStart ?cDest) 0);Controlo que la duracion no sea 0 (que la casilla inicio y la final sean diferentes)
				(> (energy ?v) (distance ?cStart ?cDest))
			)
		)
		(over all 
			(and 
				(N0-enabled ?v)
				(undocked ?v)
			)
		)
	)
	:effect(at end
			(and
				(not (at ?v ?cStart))
				(at ?v ?cDest)
				(decrease (energy ?v) (distance ?cStart ?cDest))
				(increase (total-distance ?v) (distance ?cStart ?cDest))
			)
	)
)

(:durative-action move-N1
	:parameters(?v - Vehicle ?cStart ?cDest - Coord)
	:duration (= ?duration (/ (distance ?cStart ?cDest)2))
	:condition(and
		(at start 
			(and
				(at ?v ?cStart)
				(> (/ (distance ?cStart ?cDest)2)0);Esto verifica que no nos movamos a la misma casilla que nos encontremos
				(> (energy ?v) (* (distance ?cStart ?cDest) 2));Como va el doble de rapido que en N0, logicamente gasta el doble de energia
			)
		) 
		(over all 
			(and 
				(N1-enabled ?v)
				(undocked ?v)
			)
		)
	)
	:effect(at end
			(and
				(not (at ?v ?cStart))
				(at ?v ?cDest)
				(increase (total-distance ?v) (distance ?cStart ?cDest))
				(decrease (energy ?v) (* (distance ?cStart ?cDest)2))
			)
	)
)
			

(:durative-action send-image
	:parameters(?v - Vehicle ?p - Pan ?t - Tilt ?c - Coord)
	:duration(= ?duration 1)
	:condition(and
		(at start 
			(and
				(image-not-sent ?p ?t ?c ?v)
				(> (energy ?v) 1)
			)
		)
		(over all 
			(image-taken ?p ?t ?c ?v)
		)
	)
	:effect(at end (and
			(not (image-not-sent ?p ?t ?c ?v))
			(image-sent ?p ?t ?c ?v)
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
	:duration(= ?duration (* (- 200 (energy ?v)) 2)) ;la duracion es el doble de la energia que tenemos que cargar (con 200 esta llena)
	:condition(over all 
			(docked ?v)
	)
	:effect(at end 
			(increase (energy ?v) (- 200 (energy ?v)))
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
)
