#![feature(lang_items)]
#![no_std]

extern crate rlibc;
extern crate vga;

use vga::buffer::print_message;

#[lang = "eh_personality"]
extern "C" fn eh_personality() {}

#[no_mangle]
#[lang = "panic_fmt"]
extern "C" fn rust_begin_panic() -> ! {
    loop {}
}

#[no_mangle]
pub extern "C" fn __floatundisf() {}
#[no_mangle]
pub extern "C" fn __eqsf2() {}
#[no_mangle]
pub extern "C" fn __floatundidf() {}
#[no_mangle]
pub extern "C" fn __eqdf2() {}
#[no_mangle]
pub extern "C" fn __mulsf3() {}
#[no_mangle]
pub extern "C" fn __muldf3() {}
#[no_mangle]
pub extern "C" fn __divsf3() {}
#[no_mangle]
pub extern "C" fn __divdf3() {}
#[no_mangle]
pub extern "C" fn __udivti3() {}
#[no_mangle]
pub extern "C" fn __umodti3() {}
#[no_mangle]
pub extern "C" fn __muloti4() {}

#[no_mangle]
pub extern "C" fn kernel_main() -> ! {
    // Test
    print_message();
    loop {}
}
