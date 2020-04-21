(define (domain building)
    (:requirements :strips :typing :durative-actions :equality :fluents :typing)
    (:types lift - object fastlift - lift person - object number - object floor - object)

    (:functions
    	(fast-move-cost ?l -fastlift)
    	(slow-move-cost ?l -slowfitlift)
		(persons-lift ?l S)
		(total-cost)
    )

    (:predicates
        (lift-on-floor ?l - lift ?f -floor)
        (person-on-floor ?p -person ?f -floor)
        (person-on-lift ?p -person ?l -lift)
		(on ?f1 ?f2 -floor)
		(accessible ?l -lift ?f -floor)
		(next ?f1 ?f2 -floor)
    )
    
    (:action fast-move-up
        :parameters (?l -fastlift ?f1 ?f2-floor)
        :precondition (and (on ?f1 ?f2) 
			(accesible ?l ?f2)
            (lift-on-floor ?l ?f1))
        :effect (and (lift-on-floor ?l ?f2)
		(not (lift-on-floor ?l ?f2))
		(increase (total-cost) (fast-move-cost ?l))
    )

    (:action slow-move-up
        :parameters (?l -slowlift ?f1 ?f2 -floor)
        :precondition (and (on ?f1 ?f2)
			(accesible ?l ?f2)
            (lift-on-floor ?l ?f1))
        :effect (and (lift-on-floor ?l ?f2)
		(not (lift-on-floor ?l ?f2))
		(increase (total-cost) (slow-move-cost ?l))
    )

    (:action fast-move-down
        :parameters (?l -slowlift ?f1 ?f2 -floor)
        :precondition (and (on ?f2 ?f1)
			(accesible ?l ?f2)
            (lift-on-floor ?l ?f1))
        :effect (and (lift-on-floor ?l ?f2)
		(not (lift-on-floor ?l ?f2))
		(increase (total-cost) (slow-move-cost ?l))
    )

    (:action slow-move-down
        :parameters (?l -slowlift ?f1 ?f2 -floor)
        :precondition (and (on ?f2 ?f1)
			(accesible ?l ?f2)
            (lift-on-floor ?l ?f1))
        :effect (and (lift-on-floor ?l ?f2)
		(not (lift-on-floor ?l ?f2))
		(increase (total-cost) (slow-move-cost ?l))
    )

	(:action board
        :parameters (?p -person ?f -floor ?l -lift ?num1 ?num2 -number)
        :precondition (and (person-on-floor ?p ?f)
			(lift-on-floor ?l ?f)
			(= ?num1 ?num2))
        :effect (and (lift-on-floor ?l ?f1)
		(increase (total-cost) (slow-move-cost ?l))
    )
	
	(:action leave
        :parameters (?p -person ?f -floor ?l -lift ?num1 ?num2 -number)
        :precondition (and (person-on-floor ?p ?f)
			(lift-on-floor ?l ?f)
			(= ?num1 ?num2))
        :effect (and (lift-on-floor ?l ?f1)
		(increase (total-cost) (slow-move-cost ?l))
    )

	

)
