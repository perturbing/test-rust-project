use blstrs::Scalar;
use ff::Field;
use rand::thread_rng;

#[no_mangle]
pub extern "C" fn random_scalar(a: *mut Scalar) {
    println!("Pointer address received in Rust: {:p}", a);

    if !a.is_null() {
        println!("Received scalar in Rust: {:?}", unsafe { *a });
        let mut rng = thread_rng();
        unsafe {
            *a = Scalar::random(&mut rng);
            println!("Modified the scalar in place: {:?}", *a);
        }
    } else {
        println!("Received null pointer!");
    }
}
