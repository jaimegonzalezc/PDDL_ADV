(define (problem problem-planetary-explorations)
    (:domain rover-domain)
    (:objects
        r1 r2 - rover
        x y - place
    )
    (:init
        (= (battery-level r1) 100)
        (is_on ?x -place)
        (can_move ?x ?y -place)
        
    )
    (:goal (is_on ?y))
        
    )