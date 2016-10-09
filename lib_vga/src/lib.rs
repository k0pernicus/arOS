#![no_std]

const COLUMNS: usize = 20;
const ROWS: usize = 80;

static mut VGA: u64 = 0xb8000;

/// Alias type for console color code
type ColorCode = u8;
type Unicode = u8;

/// Rust enumeration of colors.
/// Each color is an hexadecimal value to represent a color for VGA display.
/// 16 colors are available in this crate.
pub enum Color {
    Black = 0x0,
    Blue = 0x1,
    Green = 0x2,
    Cyan = 0x3,
    Red = 0x4,
    Magenta = 0x5,
    Brown = 0x6,
    Gray = 0x7,
    DarkGray = 0x8,
    BrightBlue = 0x9,
    BrightGreen = 0xA,
    BrightCyan = 0xB,
    BrightRed = 0xC,
    BrightMagenta = 0xD,
    Yellow = 0xE,
    White = 0xF,
}

/// Function to get the color code of the association of two colors.
/// These two colors are foreground and background colors.
pub fn get_colorcode_from(background_color: Color, foreground_color: Color) -> ColorCode {
    ((background_color) as ColorCode) << 4 + (foreground_color as ColorCode)
}

// macro_rules! println {
//     ($e:expr) => {
//         unsafe {
//             let mut offset : u64 = 0;
//             for c in $e.chars() {
//                 *((VGA + offset) as *mut u64) = c as u64;
//                 offset += 1;
//                 *((VGA + offset) as *mut u64) = COLOR;
//                 offset += 1;
//             }
//             *((VGA + offset) as *mut u64) = 0x0A;
//             VGA = VGA + 160;
//         }
//     };
// }

/// Structure to implement a console
/// This console contains the color to display the text, associated to the background color code,
/// and a buffer that contains the text which is displayed
pub struct Console {
    buffer: [Unicode; COLUMNS * ROWS],
    color: ColorCode,
    position: u16,
}

impl Console {
    
    pub fn new(console_color: ColorCode) -> Self {
        Console {
            buffer: [0; COLUMNS * ROWS],
            color: console_color,
            position: 0,
        }
    }

    pub fn write_byte(&mut self, byte: u8) {
        if (self.position + 2) as usize >= (COLUMNS * ROWS) {
            self.position = 0;
        }
        self.buffer[self.position as usize] = byte;
        self.buffer[(self.position + 1) as usize] = self.color;
        self.position += 2;
    }

}
