#![feature(lang_items)]
#![no_std]

#[lang = "eh_personality"]
extern fn eh_personality() {
}

#[lang = "panic_fmt"]
extern fn rust_begin_panic() -> ! {
    loop {}
}

#[no_mangle]
pub extern fn kernel_main() -> ! {
    unsafe {
        let vga = 0xb8000 as *mut u64;

        *vga = 0x2f6c2f6c2f652f48;

        let vga2 = 0xb8008 as *mut u64;
        
        *vga2 = 0x2f6f2f772f202f6f;

        let vga3 = 0xb8010 as *mut u64;

        *vga3 = 0x2f202f642f6c2f72;

        let vga4 = 0xb8018 as *mut u64;

        *vga4 = 0x2f6d2f6f2f722f66;

        let vga5 = 0xb8020 as *mut u64;

        *vga5 = 0x2f732f752f722f20;

        let vga6 = 0xb8028 as *mut u64;

        *vga6 = 0x2f212f74;
    }
    loop {}
}
