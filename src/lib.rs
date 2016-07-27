#![feature(lang_items)]
#![no_std]

static mut VGA: u64 = 0xb8000;
static COLOUR: u64 = 0x02;

macro_rules! k_println {
    ($e:expr) => {
        unsafe {
            let mut offset : u64 = 0;
            for c in $e.chars() {
                *((VGA + offset) as *mut u64) = c as u64;
                offset += 1;
                *((VGA + offset) as *mut u64) = COLOUR;
                offset += 1;
            }
            *((VGA + offset) as *mut u64) = 0x0A;
            VGA = VGA + 160;
        }
    };
}

#[lang = "eh_personality"]
extern fn eh_personality() {
}

#[lang = "panic_fmt"]
extern fn rust_begin_panic() -> ! {
    loop {}
}

#[no_mangle]
pub extern fn kernel_main() -> ! {
    // k_println!("Hello");
    k_println!("arOS - another rust Operating System");
    k_println!("system version 0.0.1");
    k_println!("");
    k_println!("Welcome user!");

    loop {}
}
