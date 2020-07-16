use hlua::Lua;
use std::ffi::CStr;
use std::ffi::CString;
use std::os::raw::c_char;
use std::process::{Command, Stdio};
use std::thread;
use std::time::Duration;

#[no_mangle]
pub extern "C" fn start_thread(v: *const c_char, duration: i64, f: fn(v: *const c_char, len: i8)) {
    unsafe {
        let code = CStr::from_ptr(v).to_string_lossy().into_owned();
        let mut lua = Lua::new();
        lua.openlibs();
        thread::spawn(move || {
            let result = lua.execute::<String>(&code);
            match result {
                Ok(result) => {
                    let len = result.len();
                    let c_result = CString::new(result).unwrap();
                    let ptr = c_result.as_ptr();
                    if duration != 0 {
                        thread::sleep(Duration::from_millis(duration as u64));
                    }
                    f(ptr, len as i8);
                }
                Err(err) => {
                    println!("Return Type was not String {}", err);
                    let c_result = CString::new("").unwrap();
                    let ptr = c_result.as_ptr();
                    f(ptr, 0);
                }
            }
            // .expect("The lua code return type is not String");
            println!("Thread Ended");
        });
    }
}

#[no_mangle]
pub extern "C" fn spawn_process(process: *const c_char, args: *const c_char) {
    unsafe {
        let name = CStr::from_ptr(process).to_string_lossy().into_owned();
        let argv = CStr::from_ptr(args).to_string_lossy().into_owned();
        thread::spawn(move || {
            let arguments: Vec<&str> = argv.split(' ').collect();
            let mut process = Command::new(name)
                .stdin(Stdio::piped())
                .args(arguments)
                .spawn()
                .expect("Process could not be spawned");
            process.wait().expect("Unexpected Error");
        });
    }
}