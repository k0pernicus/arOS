use core::ptr::Unique;

pub static mut VGA_BUFFER_ADDRESS: u64 = 0xb8000;
const BUFFER_LENGTH: usize = 80;
const BUFFER_HEIGHT: usize = 24;

use color::ColorCode;

type Char = (u8, ColorCode);

pub struct Buffer {
    content: [[Char; BUFFER_LENGTH]; BUFFER_HEIGHT],
}

pub struct Writer {
    column_position: usize,
    color_code: ColorCode,
    buffer: Unique<Buffer>
}

impl Writer {
    pub fn new(column_position: usize,
               color_code: ColorCode,
               buffer: Unique<Buffer>
    ) -> Writer {
        Writer {
            column_position,
            color_code,
            buffer
        }
    }
    pub fn write(&mut self, byte: u8) {
        if self.column_position >= BUFFER_LENGTH {
            // Do something
        }
        // Clone the column_position fields
        let row = BUFFER_HEIGHT - 1;
        let col = self.column_position;
        let color_code = self.color_code;
        // Change the content buffer
        self.buffer().content[row][col] = (byte, color_code);
        self.column_position += 1;
    }

    fn buffer(&mut self) -> &mut Buffer {
        unsafe { self.buffer.as_mut() }
    } 
}

pub fn print_message() {
    let mut writer = Writer::new(
        0,
        ColorCode::default(),
        unsafe {
            Unique::new_unchecked(0xb8000 as *mut _)
        }
    );
    writer.write(b'H');
}