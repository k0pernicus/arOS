#![feature(lang_items)]
#![no_std]

extern crate vga;

#[lang = "eh_personality"]
extern fn eh_personality() {
}

#[lang = "panic_fmt"]
extern fn rust_begin_panic() -> ! {
    loop {}
}

#[no_mangle]
pub extern fn kernel_main() -> ! {
    // println!("arOS - another rust Operating System");
    // println!("system version 0.0.1");
    // println!("");
    // println!("Hello World!");

    loop {}
}
