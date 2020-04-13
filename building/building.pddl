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
        :parameters (?l -fastlift ?f1 ?f2 -floor)
        :precondition (and (on ?f1 ?f2)
            (lift-on-floor ?l ?f1))
        :effect (lift-on-floor ?l ?f2)
    )
    (:action slow-move-up
        :parameters (?l -slowlift ?f1 ?f2 -floor)
        :precondition (and (on ?f1 ?f2)
            (lift-on-floor ?l ?f2))
        :effect (lift-on-floor ?l ?f1)
    )
)
