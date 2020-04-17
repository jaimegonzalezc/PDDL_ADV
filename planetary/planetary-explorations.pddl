(define (domain planetary-explorations)
(:requirements :typing :strips :fluents : durative-action )
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
    :condition (and (over all (not (is_recharging? ?rover))(not (is_taking_picture? ?rover))  (not (is_drilling? ?rover)) (not(is_communicating? ?rover))
    (not (is_analizing? ?rover))) (at start(is_on ?x)) (at end(> (battery-level ?rover) (* ?duration (speed ?rover)))))
    :effect (and(decrease battery-level (* ?duration (speed ?rover))) (at end(is_on ?y)(not(is_moving? ?rover)))(at start (not (is_on ?x)) (is_moving? ?rover)))
    
)

(:durative-action recharge
    :parameters (?rover -rover)  
    :duration (= ?duration 5)
    :condition (over all(not (is_moving? ?rover)))
    :effect (and(increase(battery-level ?rover) 20)(at start (is_recharging? ?rover) (at end(not (is_recharging? ?rover)))))
)


 (:action take_pictures
  :parameters ()
  :precondition ()
  :effect ())

               

(:durative-action drilling
    :parameters (?place -place ?rover -rover)
    :duration (= ?duration 15)
    :condition (and(is_on ?place)(not(is_moving? ?rover))(> (battery-level ?rover)0))
    :effect (and (at start(is_drilling? ?rover))(at end (not (is_drilling? ?rover))))
)

(:durative-action analyize_samples
    :parameters (?sample -samples ?rover -rover ?place -place)
    :duration (= ?duration 15)
    :condition (and(over all(is_on ?place)) (over all(not(can_move ?rover)) (at end(> (battery-level ?rover)0))))
    :effect (and (at start (is_analizing? ?rover)) (at end(not(is_analizing? ?rover))))
)

(:durative-action earth-comunnication
    :parameters (?rover -rover ?earth -planet ?place -place)
    :duration (= ?duration 15)
    :condition (and(is_on ?place)(not is_comunicated ?rover ?earth)(not(can_move ?rover)))(> (battery-level ?rover)0)
    :effect (and(is_comunicated ?rover ?earth)(can_move ?rover))
)


)
