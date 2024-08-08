use blstrs::Scalar;
use ff::Field;
use rand::thread_rng;

#[no_mangle]
pub extern "C" fn random_scalar(a: *const Scalar) -> Scalar {
    if a.is_null() {
        println!("Received null pointer");
        return Scalar::ZERO;
    }
    let a_scalar = unsafe { *a };
    println!("a: {:?}", a_scalar);
    let mut rng = thread_rng();
    let b = Scalar::random(&mut rng);
    println!("b: {:?}", b);
    return b;
}
