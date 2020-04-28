(define (problem problem-ejercicio4)
    (:domain ejercicio4)  
    (:objects
        truck motorbike - vehicle
        warehouse a b c - place
        p1 p2 p3 p4 - package

    )
    (:init
    (= (total_fuel_used truck) 0)
    (not_is_loading p1)
    (not_is_loading p2)
    (not_is_loading p3)
    (not_is_loading p4)
    (not_is_recharging truck)
    (not_is_recharging motorbike)
    (= (total_fuel_used motorbike) 0)
    (package_on_place p1 warehouse)
    (package_on_place p2 warehouse)
    (package_on_place p3 warehouse)
    (package_on_place p4 warehouse)
    (vehicle_on_place truck warehouse)
    (vehicle_on_place motorbike warehouse)
    (= (time_required p1) 3)
    (= (time_required p2) 5)
    (= (time_required p3) 1)
    (= (time_required p4) 8)
    (= (space truck) 2)
    (= (space motorbike) 2) 
    (= (speed truck) 1)
    (= (speed motorbike) 2)
    (= (distance warehouse a) 5)
    (= (distance warehouse b) 10)
    (= (distance warehouse c) 15)
    (= (distance a b) 5)
    (= (distance a warehouse) 5)
    (= (distance a c) 10)
    (= (distance b a) 5)
    (= (distance b warehouse) 10)
    (= (distance b c) 5)
    (= (distance c a) 10)
    (= (distance c b) 5)
    (= (distance c warehouse) 15)
    (= (fuel_level truck) 40)
    (= (fuel_level motorbike) 20)
    (= (max_fuel_level truck) 40)
    (= (max_fuel_level truck) 20)
    )
    (:goal (and 
	(package_on_place p1 a)
    (package_on_place p2 b)
    (package_on_place p3 a)
    (package_on_place p4 c)
	))
(:constraints () )

(:metric minimize (+ (total_fuel_used truck) (total_fuel_used motorbike)))

)
