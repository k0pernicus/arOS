/// Rust enumeration of colors.
/// Each color is an hexadecimal value to represent a color for VGA display.
/// 16 colors are available in this crate.
enum Color {
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
fn get_colorcode_from(background_color: Color, foreground_color: Color) -> u8 {
    ((background_color) as u8) << 4 + (foreground_color as u8)
}
