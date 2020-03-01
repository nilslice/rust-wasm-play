(module
    (memory $mem 1)

    (global $WHITE i32 (i32.const 1))
    (global $BLACK i32 (i32.const 2))
    (global $CROWN i32 (i32.const 4))

    ;; determine if a piece has been crowned
    (func $isCrowned (param $piece i32) (result i32)
        (i32.eq
            (i32.and (get_local $piece) (get_global $CROWN))
            (get_global $CROWN)
        )
    )

    ;; determine if a piece is white
    (func $isWhite (param $piece i32) (result i32)
        (i32.eq
            (i32.and (get_local $piece) (get_global $WHITE))
            (get_global $WHITE)
        )
    )

    ;; determine if a piece is black
    (func $isBlack (param $piece i32) (result i32)
        (i32.eq
            (i32.and (get_local $piece) (get_global $BLACK))
            (get_global $BLACK)
        )
    )

    ;; adds a crown to a given piece (no mutation)
    (func $withCrown (param $piece i32) (result i32)
        (i32.or (get_local $piece) (get_global $CROWN))
    )

    ;; removes a crown from a given piece (no mutation)
    (func $withoutCrown (param $piece i32) (result i32)
        (i32.and (get_local $piece) (i32.const 3))
    )

    (func $indexForPosition (param $x i32) (param $y i32) (result i32)
        ;; i = y*8 + x
        (i32.add 
            (i32.mul (i32.const 8) (get_local $y))
            (get_local $x)
        )
    )

    (func $offsetForPosition (param $x i32) (param $y i32) (result i32)
        ;; offset = index*4
        (i32.mul
            (call $indexForPosition (get_local $x) (get_local $y))
            (i32.const 4)
        )
    )

    ;; exports specifically for tests
    (export "index_for_position" (func $indexForPosition))
    (export "offset_for_position" (func $offsetForPosition))
    (export "is_crowned" (func $isCrowned))
    (export "is_white" (func $isWhite))
    (export "is_black" (func $isBlack))
    (func (export "FLAG_WHITE") (result i32) get_global $WHITE)
    (func (export "FLAG_BLACK") (result i32) get_global $BLACK)
    (func (export "FLAG_CROWN") (result i32) get_global $CROWN)
    (export "with_crown" (func $withCrown))
    (export "without_crown" (func $withoutCrown))
)