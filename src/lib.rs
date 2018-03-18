#![feature(lang_items)]
#![no_std]

extern crate vga;

use vga::buffer::print_message;

#[lang = "eh_personality"]
extern "C" fn eh_personality() {}

#[lang = "panic_fmt"]
extern "C" fn rust_begin_panic() -> ! {
    loop {}
}

#[no_mangle]
pub extern "C" fn kernel_main() -> ! {
    // Test
    print_message();
    loop {}
}
