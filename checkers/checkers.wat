(module
    (memory $mem 1)

    (global $WHITE i32 (i32.const 1))
    (global $BLACK i32 (i32.const 2))
    (global $CROWN i32 (i32.const 4))

    (global $currentTurn (mut i32) (i32.const 0))

    ;; gets the current turn owner (white or black)
    (func $getTurnOwner (result i32)
        (call $withoutCrown (get_global $currentTurn))
    )

    ;;  at the end of a turn, switch the turn owner to the other player
    (func $toggleTurnOwner
        (if (i32.eq (call $getTurnOwner) (get_global $WHITE))
            (then (call $setTurnOwner (get_global $BLACK)))
        )
    )

    ;; set the turn owner to white or black
    (func $setTurnOwner (param $piece i32)
        (set_global $currentTurn (call $withoutCrown (get_local $piece)))
    )

    ;; determine if it's a players turn
    (func $isPlayersTurn (param $player i32) (result i32)
        (i32.gt_s
            (i32.and (call $withoutCrown (get_local $player)) (call $getTurnOwner))
            (i32.const 0)
        )
    )

    ;; set a piece on the board
    (func $setPiece (param $x i32) (param $y i32) (param $piece i32)
        (i32.store
            (call $offsetForPosition (get_local $x) (get_local $y))
            (get_local $piece)
        )
    )

    ;; get a piece from the board. out-of-range causes a trap.
    (func $getPiece (param $x i32) (param $y i32) (result i32)
        (if (result i32)
            (block (result i32)
                (i32.and
                    (call $inRange
                        (i32.const 0)
                        (i32.const 7)
                        (get_local $x)
                    )
                    (call $inRange
                        (i32.const 0)
                        (i32.const 7)
                        (get_local $y)
                    )
                )
            )
            (then
                (i32.load
                    (call $offsetForPosition
                        (get_local $x)
                        (get_local $y)
                    )
                )
            )
            (else 
                (unreachable)
            )
        )
    )

    ;; detect if values are in within range (inclusive high and low)
    (func $inRange (param $low i32) (param $high i32) (param $val i32) (result i32)
        (i32.and
            (i32.ge_s (get_local $val) (get_local $low))
            (i32.le_s (get_local $val) (get_local $high))
        )
    )

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
    (export "in_range" (func $inRange))
    (export "get_piece" (func $getPiece))
    (export "set_piece" (func $setPiece))
    (export "get_turn_owner" (func $getTurnOwner))
    (export "toggle_turn_owner" (func $toggleTurnOwner))
    (export "set_turn_owner" (func $setTurnOwner))
    (export "is_players_turn" (func $isPlayersTurn))
)