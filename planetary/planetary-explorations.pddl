(define (domain planetary-explorations)
(:requirements :typing :strips :fluents :durative-actions )
(:types rover place planet direction samples panels speed)
(:predicates (is_on ?place -place)
(is_communicating? ?rover -rover)
(is_drilling? ?place -place)
(is_taking_image? ?rover -rover)
(is_analizing? ?rover -rover)
(is_recharging? ?rover -rover)
(is_moving? ?rover -rover)
)

(:functions (battery-level ?rover -rover)
(distance ?x ?y -place)
(speed ?rover -rover))


(:durative-action move 
    :parameters (?x ?y -place ?rover -rover)
    :duration (= ?duration (/ (distance-total ?x ?y) (speed ?rover)))
    :condition (and (over all (not (is_recharging? ?rover)))(over all(not (is_taking_picture? ?rover)))(over all(not (is_drilling? ?rover)))(over all(not(is_communicating? ?rover)))
    (over all(not (is_analizing? ?rover)))(at start(is_on ?x)) (at end(> (battery-level ?rover) (*  duration (speed ?rover)))))
    :effect (and(at end(decrease battery-level (* duration (speed ?rover)))) (at end(is_on ?y))(at end(not(is_moving? ?rover)))(at start (not (is_on ?x))) (at start (is_moving? ?rover)))
    
)

(:durative-action recharge
    :parameters (?rover -rover)  
    :duration (= ?duration 5)
    :condition (over all(not (is_moving? ?rover)))
    :effect (and(over all(increase(battery-level ?rover) 20)) (at start (is_recharging? ?rover)) (at end(not (is_recharging? ?rover))))
)




               

(:durative-action drilling
    :parameters (?place -place ?rover -rover)
    :duration (= ?duration 15)
    :condition (and(over all(is_on ?place)(not(is_moving? ?rover))))
    :effect (and (at start(is_drilling? ?rover))(at end (not (is_drilling? ?rover))))
)

(:durative-action analyize_samples
    :parameters (?rover -rover ?place -place)
    :duration (= ?duration 15)
    :condition (and(over all(is_on ?place)) (over all(not(is_moving? ?rover))))
    :effect (and (at start (is_analizing? ?rover)) (at end(not(is_analizing? ?rover))))
)

(:durative-action earth-comunnication
    :parameters (?rover -rover ?place -place)
    :duration (= ?duration 15)
    :condition (and(over all(is_on ?place))(over all(not(is_moving? ?rover))))
    :effect (and(at start(is_comunicated? ?rover ?earth)) (at end (not(is_comunicated? ?rover ?earth))))
)
)