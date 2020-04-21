(define (domain ejercicio4)
(:requirements :typing :strips :fluents :durative-actions )
(:types vehicle place package worker)
(:predicates 

(package_on_place ?place -place)
(vehicle_on_place ?place - place)
(is_loaded ?vehicle -vehicle ?package -package)
(not_is_loading ?package -package)
(is_recharging ?vehicle)


)

(:functions 
(time_required ?package -package) ;Time required to load package
(space ?vehicle - vehicle) ;Free space of the vehicle
(speed ?vehicle -vehicle)
(distance ?a ?b -place)
(fuel-level ?vehicle - vehicle)
)

(:durative-action load
    :parameters (?place - place ?package -package ?vehicle -vehicle)
    :duration (= ?duration (time_required ?package))
    :condition (and 
        (at start (and (package_on_place ?place -place) (vehicle_on_place ?place -place) (not_is_loading ?package)
        ))
        (over all (and (> (space ?vehicle) 0)
        ))
    )
    :effect (and 
        (at start (not( not_is_loading ?package - package))
        ))
        (at end (and (not_is_loading ?package -package) (is_loaded ?vehicle -vehicle ?package -package) (not (package_on_place ?place)) (decrease (space ?vehicle) 1)
        ))
    )
)

(:durative-action unload
    :parameters (?place - place ?package -package ?vehicle -vehicle)
    :duration (= ?duration (time_required ?package))
    :condition (and 
        (at start (and (is_loaded ?place -place ?vehicle -vehicle) (vehicle_on_place ?place -place) (not_is_loading ?package -package)
        ))

    )
    :effect (and 
        (at start (not(not_is_loading ?package - package))
        )
        (at end (and  (is_loading ?package -package) (not(is_loaded ?vehicle -vehicle))  (package_on_place ?place) (increase (space ?vehicle) 1)
        ))
    )
)


)