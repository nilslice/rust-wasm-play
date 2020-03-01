(module
    (func $add (param $lhs i32) (param $rhs i32) (result i32)
        (i32.add (get_local $lhs) (get_local $rhs))
    )

    (func $double_i32 (param $val i32) (result i32)
        (i32.mul (get_local $val) (i32.const 2))
    )
    
    (export "add" (func $add))
    (export "double_int" (func $double_i32))
)