use hlua::Lua;
use std::ffi::CStr;
use std::ffi::CString;
use std::os::raw::c_char;
use std::thread;

#[no_mangle]
pub extern "C" fn start_thread(v: *const c_char, f: fn(v: *const c_char, len: i8)) {
    unsafe {
        let code = CStr::from_ptr(v).to_string_lossy().into_owned();
        let mut lua = Lua::new();
        lua.openlibs();
        thread::spawn(move || {
            let result = lua.execute::<String>(&code).expect("The lua code return type is not String");
            let len = result.len();
            let c_result = CString::new(result).unwrap();
            let ptr = c_result.as_ptr();
            f(ptr, len as i8);
        });
    }
    println!("Thread Ended");
}
