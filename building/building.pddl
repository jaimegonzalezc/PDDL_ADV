(define (domain building)
    (:requirements :durative-actions :strips :typing :fluents)
    (:types lift -object fastlift slowlift -lift person -object number -object )

    (:functions
    	(fast-move-cost ?n1 ?n2 -number)
    	(slow-move-cost ?n1 ?n2 -number)
	    (total-cost)
    )

    (:predicates
        (lift-on-floor ?l -lift ?f -number)
        (person-on-floor ?p -person ?f -number)
        (person-on-lift ?p -person ?l -lift)
		(on ?n1 ?n2 -number)
	    (accessible ?l -lift ?f -number)
    	(next ?n1 ?n2 -number)
        (people-on-lift ?l -lift ?n -number)
    )
    
    (:durative-action fast-move-up
        :parameters (?l -fastlift ?f1 ?f2 -number)
        :duration (=?duration (fast-move-cost ?f1 ?f2))
        :condition (and (at start (and(on ?f1 ?f2)(lift-on-floor ?l ?f1))) 
            (over all (accessible ?l ?f2)))
        :effect (at end (and (lift-on-floor ?l ?f2)
		(not (lift-on-floor ?l ?f1))
		(increase (total-cost) (fast-move-cost ?f1 ?f2)))
    ))

    (:durative-action slow-move-up
        :parameters (?l -slowlift ?f1 ?f2 -number)
        :duration (=?duration (slow-move-cost ?f1 ?f2))
        :condition (and (at start (and(on ?f1 ?f2)(lift-on-floor ?l ?f1))) 
            (over all (accessible ?l ?f2)))
        :effect (at end (and (lift-on-floor ?l ?f2)
		(not (lift-on-floor ?l ?f1))
		(increase (total-cost) (slow-move-cost ?f1 ?f2 )))
    ))

    (:durative-action fast-move-down
        :parameters (?l -fastlift ?f1 ?f2 -number)
        :duration (=?duration (fast-move-cost ?f1 ?f2))
        :condition (and (at start (and(on ?f2 ?f1)(lift-on-floor ?l ?f1))) 
            (over all (accessible ?l ?f2)))
        :effect (at end(and (lift-on-floor ?l ?f2)
		(not (lift-on-floor ?l ?f1))
		(increase (total-cost) (fast-move-cost ?f1 ?f2)))
    ))

    (:durative-action slow-move-down
        :parameters (?l -slowlift ?f1 ?f2 -number)
        :duration (=?duration (slow-move-cost ?f1 ?f2))
        :condition (and (at start (and(on ?f2 ?f1)(lift-on-floor ?l ?f1))) 
            (over all (accessible ?l ?f2)))
        :effect (at end (and (lift-on-floor ?l ?f2)
		(not (lift-on-floor ?l ?f1))
		(increase (total-cost) (slow-move-cost ?f1 ?f2)))
    ))

	(:action board
        :parameters (?p -person ?f -number ?l -lift ?num1 ?num2 -number)
        :precondition (and (person-on-floor ?p ?f) 
        (lift-on-floor ?l ?f) (next ?num1 ?num2) (people-on-lift ?l ?num1))
        :effect (and (not (person-on-floor ?p ?f))
        (person-on-lift ?p ?l)(not (people-on-lift ?l ?num1)) 
        (people-on-lift ?l ?num2)
    ))
	
	(:action leave
        :parameters (?p -person ?f -number ?l -lift ?num1 ?num2 -number)
        :precondition (and (person-on-lift ?p ?l)
         (lift-on-floor ?l ?f) (next ?num2 ?num1) (people-on-lift ?l ?num1))
        :effect (and (person-on-floor ?p ?f)
        (not (person-on-lift ?p ?l))(not (people-on-lift ?l ?num1)) 
        (people-on-lift ?l ?num2)
    ))
)
