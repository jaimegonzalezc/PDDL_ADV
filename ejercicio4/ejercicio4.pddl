(define (domain ejercicio4)
(:requirements :typing :strips :fluents :durative-actions )
(:types vehicle place package worker gas_station)
(:predicates 

(package_on_place ?package -package ?place -place)
(vehicle_on_place ?vehicle -vehicle ?place - place)
(is_loaded ?vehicle -vehicle ?package -package)
(not_is_loading ?package -package)
(not_is_recharging ?vehicle)

)

(:functions 
(time_required ?package -package) ;Time required to load package
(space ?vehicle - vehicle) ;Free space of the vehicle
(speed ?vehicle -vehicle)
(distance ?a ?b -place)
(fuel_level ?vehicle - vehicle)
;(distance ?a -place ?station - gas_station)
(max_fuel_level ?vehicle -vehicle)
(total_fuel_used ?vehicle)
)

(:durative-action load
    :parameters (?place - place ?package -package ?vehicle -vehicle)
    :duration (= ?duration (time_required ?package))
    :condition (and 
        (at start (and  (not_is_loading ?package) (package_on_place ?package ?place)
        ))
        (over all (and (> (space ?vehicle) 0) (vehicle_on_place ?vehicle ?place) 
        ))
    )
    :effect (and 
        (at start(and (not( not_is_loading ?package )) (not(package_on_place ?package ?place))
        ))
        (at end (and (not_is_loading ?package ) (is_loaded ?vehicle ?package ) (decrease (space ?vehicle) 1)
        ))
    )
)

(:durative-action unload
    :parameters (?place - place ?package -package ?vehicle -vehicle)
    :duration (= ?duration (time_required ?package))
    :condition (and 
        (at start (and (is_loaded ?vehicle  ?package ) (vehicle_on_place ?vehicle ?place  ) (not_is_loading ?package )
        ))

    )
    :effect (and 
        (at start (not(not_is_loading ?package ))
        )
        (at end (and  (not_is_loading ?package ) (not(is_loaded ?vehicle ?package ))  (package_on_place ?package  ?place ) (increase (space ?vehicle) 1)
        ))
    )
)

(:durative-action refuel
    :parameters (?vehicle -vehicle)
    :duration (= ?duration (- (max_fuel_level ?vehicle) (fuel_level ?vehicle)))
    :condition (and 
        (at start  (< (fuel_level ?vehicle) 10)
        )

    )
    :effect (and 
        (at start (not(not_is_recharging ?vehicle ))
        )
        (at end (and  (not_is_recharging ?vehicle ) (increase (fuel_level ?vehicle) (max_fuel_level ?vehicle))
        ))
    )
)

(:durative-action move
    :parameters (?x ?y - place ?vehicle -vehicle)
    :duration (= ?duration (/ (distance ?x ?y) (speed ?vehicle)))
    :condition 
        (at start  (and(vehicle_on_place ?vehicle ?x) (> (fuel_level ?vehicle) (/ (distance ?x ?y) (speed ?vehicle)))))

    :effect (and 
        (at start (not(vehicle_on_place ?vehicle ?x ))
        )
        (at end (and  (vehicle_on_place ?vehicle ?y) (not(vehicle_on_place ?vehicle ?x )) (decrease (fuel_level ?vehicle) (* (distance ?x ?y) (speed ?vehicle))) (increase (total_fuel_used truck) (* (distance ?x ?y) (speed ?vehicle)))
        ))
    )
)
)