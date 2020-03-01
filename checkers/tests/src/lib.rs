#![allow(non_snake_case)]

#[wasmtime_rust::wasmtime]
pub trait CheckersTests {
    fn index_for_position(&self, x: i32, y: i32) -> i32;
    fn offset_for_position(&self, x: i32, y: i32) -> i32;

    fn FLAG_WHITE(&self) -> i32;
    fn FLAG_BLACK(&self) -> i32;
    fn FLAG_CROWN(&self) -> i32;

    fn is_white(&self, piece: i32) -> i32;
    fn is_black(&self, piece: i32) -> i32;
    fn is_crowned(&self, piece: i32) -> i32;
    fn with_crown(&self, piece: i32) -> i32;
    fn without_crown(&self, piece: i32) -> i32;
}

pub const WASM_CHECKERS: &str = "../checkers.wasm";
pub const WHITE: i32 = 0b0001;
pub const BLACK: i32 = 0b0010;
pub const CROWN: i32 = 0b0100;

#[cfg(test)]
mod tests {
    use super::*;

    fn load(module_path: &str) -> CheckersTests {
        CheckersTests::load_file(module_path).expect("failed to load wasm module")
    }

    #[test]
    fn test_index_and_offset_position() {
        let checkers = load(WASM_CHECKERS);
        assert_eq!(checkers.index_for_position(1, 2), 17);
        assert_eq!(checkers.index_for_position(3, 5), 43);
        assert_eq!(checkers.offset_for_position(1, 2), 68);
        assert_eq!(checkers.offset_for_position(3, 5), 172);
    }

    #[test]
    fn test_flag_equality() {
        let checkers = load(WASM_CHECKERS);
        assert_eq!(checkers.FLAG_WHITE(), WHITE);
        assert_eq!(checkers.FLAG_BLACK(), BLACK);
        assert_eq!(checkers.FLAG_CROWN(), CROWN);
        assert_eq!(checkers.FLAG_BLACK() | checkers.FLAG_CROWN(), 0b0110);
    }

    #[test]
    fn test_crown_add_remove() {
        let checkers = load(WASM_CHECKERS);
        assert_eq!(checkers.is_white(WHITE), 1);
        assert_eq!(checkers.is_white(BLACK), 0);

        let white_with_crown = WHITE | CROWN;
        let black_with_crown = BLACK | CROWN;
        assert_eq!(checkers.is_crowned(white_with_crown), 1);
        assert_eq!(checkers.is_crowned(black_with_crown), 1);
        assert_eq!(checkers.is_crowned(WHITE | BLACK | CROWN), 1);
        assert_eq!(checkers.without_crown(white_with_crown), WHITE);
        assert_eq!(checkers.without_crown(black_with_crown), BLACK);

        assert_eq!(checkers.with_crown(WHITE), WHITE | CROWN);
        assert_eq!(checkers.with_crown(BLACK), BLACK | CROWN);
    }
}