(define (domain cooperation)
(:requirements :typing :durative-actions :equality :fluents :constraints :preferences)
(:types UGV UAV - Vehicle
	Vehicle Basestation - object 
	NavMode Pan Tilt X Y)
(:predicates
	(in-base ?v - Vehicle)
	(my-base ?v - Vehicle ?bs - BaseStation)
	(image-taken ?P - Pan ?T - Tilt ?x - X ?y - Y)
	(image-sent ?p - Pan ?t - Tilt ?x - X ?y - Y)
	(camera-Pan ?v - Vehicle ?P - Pan)
	(camera-Tilt ?v - Vehicle ?T - Tilt)
	(at-x ?o - object ?x - X)
	(at-y ?o - object ?y - Y)
	(N0-enabled ?v - Vehicle)); si N0 no esta activado, el modo que estara activado sera el de N1
(:functions
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
		(at start (and
			(not (in-base ?v))
			(> (energy ?v) 1)))
		(over all (and
			(at-x ?bs ?x)
			(at-y ?bs ?y)
			(at-x ?v ?x)
			(at-y ?v ?y)
			(my-base ?v ?bs))))
	:effect(at end (and
			(in-base ?v)
			(decrease (energy ?v) 1))))

(:durative-action undock
	:parameters(?v - Vehicle ?bs - BaseStation ?x - X ?y - Y)
	:duration(= ?duration 1)
	:condition(and
		(at start(and 
			(in-base ?v)
			(> (energy ?v) 1)))
		(over all (and
			(at-x ?bs ?x)
			(at-y ?bs ?y)
			(at-x ?v ?x)
			(at-y ?v ?y))))
	:effect(at end (and
			(not (in-base ?v))
			(decrease (energy ?v) 1))))

(:durative-action take-photo
	:parameters (?v - Vehicle ?p - Pan ?t - Tilt ?x - X ?y - Y)
	:duration (= ?duration 1);el hecho de tomar la foto siempre dura lo mismo 
	:condition (and
		(over all (and (camera-Pan ?v ?p) (camera-Tilt ?v ?t)
			(at-x ?v ?x) (at-y ?v ?y) (not (in-base ?v))))
		(at start (and
			(not (image-taken ?p ?t ?x ?y))
			(> (energy ?v) 1))))
	:effect (at end (and 
			(image-taken ?p ?t ?x ?y)
			(decrease (energy ?v) 1))))

(:durative-action orient-camera
	:parameters (?v - Vehicle ?p ?pIni - Pan ?t ?tIni - Tilt)
	:duration (= ?duration (/ (+ (* (- (pan-number ?p) (pan-number ?pIni)) 2) (* (- (tilt-number ?t) (tilt-number ?tIni))2)) 2))
	:condition (and
		(at start (and
			(camera-Tilt ?v ?tIni)
			(camera-Pan ?v ?pIni)
			(not (camera-Tilt ?v ?t))
			(not (camera-Pan ?v ?p))
			(> (energy ?v) (/ (+ (* (- (pan-number ?p) (pan-number ?pIni)) 2) (* (- (tilt-number ?t) (tilt-number ?tIni))2)) 2))))
		(over all (not (in-base ?v))))	
	:effect(at end (and 
			(camera-Tilt ?v ?t)
			(camera-Pan ?v ?p)
			(not (camera-Tilt ?v ?tIni))
			(not (camera-Pan ?v ?pIni))
			(decrease (energy ?v) (/ (+ (* (- (pan-number ?p) (pan-number ?pIni)) 2) (* (- (tilt-number ?t) (tilt-number ?tIni))2)) 2)))))
		
(:durative-action move-N0
	:parameters(?v - Vehicle ?xStart ?xDest - X ?yStart ?yDest - Y)
	:duration (= ?duration (+(* (- (x-number ?xDest) (x-number ?xStart)) 2) (* (- (y-number ?yDest) (y-number ?yStart))2)))
	:condition(and
		(at start (and
			(at-x ?v ?xStart)
			(at-y ?v ?yStart)
			(> (energy ?v) (+(* (- (x-number ?xDest) (x-number ?xStart)) 2) (* (- (y-number ?yDest) (y-number ?yStart))2)))))
		(over all (and (N0-enabled ?v) (not (in-base ?v)))))
	:effect(at end(and
			(not (at-x ?v ?xStart))
			(not (at-y ?v ?yStart))
			(at-x ?v ?xDest)
			(at-y ?v ?yDest)
			(decrease (energy ?v) (+(* (- (x-number ?xDest) (x-number ?xStart)) 2) (* (- (y-number ?yDest) (y-number ?yStart))2)))
			(increase (total-distance ?v) (+(* (- (x-number ?xDest) (x-number ?xStart)) 2) (* (- (y-number ?yDest) (y-number ?yStart))2))))))

(:durative-action move-N1
	:parameters(?v - Vehicle ?xStart ?xDest - X ?yStart ?yDest - Y)
	:duration (= ?duration (/ (+(* (- (x-number ?xDest) (x-number ?xStart))2) (* (- (y-number ?yDest) (y-number ?yStart))2)) 2))
	:condition(and
		(at start (and
			(at-x ?v ?xStart)
			(at-y ?v ?yStart)
			(> (energy ?v) (* (/ (+(* (- (x-number ?xDest) (x-number ?xStart))2) (* (- (y-number ?yDest) (y-number ?yStart))2)) 2) 4))))
		(over all (and (not (N0-enabled ?v)) (not (in-base ?v)))))
	:effect(at end(and
			(not (at-x ?v ?xStart))
			(not (at-y ?v ?yStart))
			(at-x ?v ?xDest)
			(at-y ?v ?yDest)
			(increase (total-distance ?v) (+(* (- (x-number ?xDest) (x-number ?xStart))2) (* (- (y-number ?yDest) (y-number ?yStart))2)))
			(decrease (energy ?v) (* (/ (+(* (- (x-number ?xDest) (x-number ?xStart))2) (* (- (y-number ?yDest) (y-number ?yStart))2)) 2) 4)))))
			
(:durative-action send-image
	:parameters(?v - Vehicle ?p - Pan ?t - Tilt ?x - X ?y - Y)
	:duration(= ?duration 1)
	:condition(and
		(at start (and
			(not(image-sent ?p ?t ?x ?y))
			(> (energy ?v) 1)))
		(over all (image-taken ?p ?t ?x ?y )))
	:effect(at end (and
			(image-sent ?p ?t ?x ?y)
			(decrease (energy ?v) 1))))