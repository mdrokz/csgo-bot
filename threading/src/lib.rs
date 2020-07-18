use hlua::Lua;
use std::ffi::CStr;
use std::ffi::CString;
use std::io::prelude::*;
use std::os::raw::c_char;
use std::os::unix::net::{UnixListener, UnixStream};
use std::process::Command;
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
                .args(arguments)
                .spawn()
                .expect("Process could not be spawned");
            process.wait().expect("Unexpected Error");
        });
    }
}

#[no_mangle]
pub extern "C" fn bind_domain_socket(path: *const c_char) {
    unsafe {
        let socket_path = CStr::from_ptr(path).to_string_lossy().into_owned();
        let listener = match UnixListener::bind(socket_path) {
            Ok(v) => v,
            Err(e) => {
                println!("Couldn't connect: {:?}", e);
                return;
            }
        };

        thread::spawn(move || {
            for stream in listener.incoming() {
                match stream {
                    Ok(stream) => {
                        thread::spawn(|| handle_client(stream));
                    }
                    Err(e) => {
                        println!("Unexpected Error {:?}", e);
                        break;
                    }
                }
            }
        });
    }
}

pub fn handle_client(stream: UnixStream) {}

#[no_mangle]
pub extern "C" fn connect_to_domain_socket(
    path: *const c_char,
    data: *const c_char,
    f: fn(v: *const c_char, len: i8),
) {
    unsafe {
        let socket_path = CStr::from_ptr(path).to_string_lossy().into_owned();
        let data = CStr::from_ptr(data).to_string_lossy().into_owned();
        let mut stream = match UnixStream::connect(&socket_path) {
            Ok(v) => {
                println!("Connected to {}", &socket_path);
                v
            }
            Err(e) => {
                println!("Couldnt Connect {:?}", e);
                return;
            }
        };
        stream
            .write_all(data.as_bytes())
            .expect("Couldnt Write Data To Socket");
        let mut res = String::new();

        match stream.read_to_string(&mut res) {
            Ok(bytes) => {
                println!("Read {} Bytes", bytes);
                let len = res.len();
                let c_result = CString::new(res).unwrap();
                let ptr = c_result.as_ptr();
                f(ptr, len as i8);
            }
            Err(e) => {
                println!("Couldnt read Data from socket Error:{:?}", e);
            }
        }
    }
}
