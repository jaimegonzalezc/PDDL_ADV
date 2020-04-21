﻿(define (domain planetary-explorations)
(:requirements :typing :strips :fluents :durative-actions )
(:types rover place planet direction samples panels speed)
(:predicates 
(is_on ?rover -rover ?place -place)
(is_communicating? ?rover -rover)
(is_drilling? ?rover -rover)
(is_taking_pictures? ?rover -rover)
(is_analizing? ?rover -rover)
(is_recharging? ?rover -rover)
(is_moving? ?rover -rover)
(has_comunicated ?rover -rover ?place -place)
(has_drilled ?rover -rover ?place -place)
(has_taken_picture ?rover -rover ?place -place)
(has_analized ?rover -rover ?place -place)
(has_extended_solar_panels ?rover -rover)
)

(:functions (battery-level ?rover -rover)
(distance ?x ?y -place)
(speed ?rover -rover)
(total_battery_used ?rover))


(:durative-action move 
    :parameters (?x ?y -place ?rover -rover)
    :duration (= ?duration (/ (distance ?x ?y) (speed ?rover)))
    :condition (and (over all (not (is_recharging? ?rover)))(over all(not (is_taking_pictures? ?rover)))(over all(not (is_drilling? ?rover)))(over all(not(is_communicating? ?rover)))
    (over all(not (is_analizing? ?rover)))(at start(is_on ?rover ?x)) (at start(> (battery-level ?rover) (* (speed ?rover) (/ (distance ?x ?y) (speed ?rover))))))
    :effect (and(at end(decrease (battery-level ?rover) (* (speed ?rover) (/ (distance ?x ?y) (speed ?rover))))) (at end(is_on ?rover ?y))(at end(not(is_moving? ?rover)))(at start (not (is_on ?rover ?x))) (at start (is_moving? ?rover)) (at end (increase (total_battery_used ?rover) 10)))
    
)

(:durative-action extend-solar-panels
    :parameters (?place -place ?rover -rover)
    :duration (= ?duration 5)
    :condition (and(over all(is_on ?rover ?place))(over all(not(is_moving? ?rover))))
    :effect  (at end(has_extended_solar_panels ?rover))
)
(:durative-action retract-solar-panels
    :parameters (?place -place ?rover -rover)
    :duration (= ?duration 5)
    :condition (and(over all(is_on ?rover ?place))(over all(not(is_moving? ?rover))))
    :effect  (at end(not (has_extended_solar_panels ?rover)))
)

(:durative-action recharge
    :parameters (?rover -rover)  
    :duration (= ?duration 10)
    :condition (over all(not (is_moving? ?rover)))
    :effect (and( at end(increase(battery-level ?rover) 20)) (at start (is_recharging? ?rover)) (at end(not (is_recharging? ?rover))))
)

(:durative-action take-pictures
    :parameters (?place -place ?rover -rover)
    :duration (= ?duration 15)
    :condition (and(over all(is_on ?rover ?place))(over all(not(is_moving? ?rover))))
    :effect (and (at start(is_taking_pictures? ?rover))(at end (not (is_taking_pictures? ?rover)))(at end (has_taken_picture ?rover ?place)))
)


               

(:durative-action drilling
    :parameters (?place -place ?rover -rover)
    :duration (= ?duration 15)
    :condition (and(over all(is_on ?rover ?place))(over all(not(is_moving? ?rover))))
    :effect (and (at start(is_drilling? ?rover))(at end (not (is_drilling? ?rover)))(at end (has_drilled ?rover ?place)))
)

(:durative-action analyize_samples
    :parameters (?rover -rover ?place -place)
    :duration (= ?duration 15)
    :condition (and(over all(is_on ?rover ?place)) (over all(not(is_moving? ?rover))))
    :effect (and (at start (is_analizing? ?rover)) (at end(not(is_analizing? ?rover)))(at end(has_analized ?rover ?place)))
)

(:durative-action earth-comunnication
    :parameters (?rover -rover ?place -place)
    :duration (= ?duration 15)
    :condition (and(over all(is_on ?rover ?place))(over all(not(is_moving? ?rover))))
    :effect (and(at start(is_communicating? ?rover)) (at end (not(is_communicating? ?rover)))(at end (has_comunicated ?rover ?place)))
)
)
