(define (domain building)

    (:requirements
	:strips 
	:typing
        :durative-actions	
        :equality
        :fluents
        :typing
    )

    (:types lift - object 
           slowlift fastlift - lift
   	  	   person - object
           number - object
           floor - object
    )

    (:functions
    	(fast-move-cost ?l -fastlift)
    	(slow-move-cost ?l -slowfitlift)
	(total-cost)
    )

    (:predicates
        (lift-on-floor ?l - lift ?f -floor)
        (person-on-floor ?p -person ?f -floor)
        (person-on-lift ?p -person ?l -lift)
		(on ?f1 ?f2 -floor)
		(accessible ?l -lift ?f -floor)
    )
    
    (:action get-on
    	:parameters (?p -person ?l -lift))

    (:action fast-move-up
        :parameters (?l -fastlift ?f1 ?f2 ?f3-floor)
        :precondition (and (on ?f1 ?f2) (on ?f2 ?f3)
            (lift-on-floor ?l ?f1))
        :effect (and (lift-on-floor ?l ?f3)
		(increase (total-cost) 1)
    )

    (:action slow-move-up
        :parameters (?l -slowlift ?f1 ?f2 -floor)
        :precondition (and (on ?f1 ?f2)
            (lift-on-floor ?l ?f1))
        :effect (and (lift-on-floor ?l ?f2)
		(increase (total-cost) 2)
    )

    (:action fast-move-down
        :parameters (?l -fastlift ?f1 ?f2 ?f3-floor)
        :precondition (and (on ?f1 ?f2) (on ?f2 ?f3)
            (lift-on-floor ?l ?f3))
        :effect (and (lift-on-floor ?l ?f1)
		(increase (total-cost) 1)
    )

    (:action slow-move-down
        :parameters (?l -slowlift ?f1 ?f2 -floor)
        :precondition (and (on ?f1 ?f2)
            (lift-on-floor ?l ?f2))
        :effect (and (lift-on-floor ?l ?f1)
		(increase (total-cost) 2)
    )
)
