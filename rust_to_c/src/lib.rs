use blstrs::Scalar;
use ff::Field;
use rand::thread_rng;

#[no_mangle]
pub extern "C" fn random_scalar(a: *mut Scalar) -> Scalar {
    println!("Pointer address received in Rust: {:p}", a);

    if a.is_null() {
        println!("Received null pointer!");
    } else {
        println!("input is: {:?}", a);
    }

    let mut rng = thread_rng();
    let b = Scalar::random(&mut rng);
    println!("Generated random scalar: {:?}", b);
    return b;
}