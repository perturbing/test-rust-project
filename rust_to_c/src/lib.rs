use blstrs::Scalar;
use ff::Field;
use rand::thread_rng;

#[no_mangle]
pub extern "C" fn random_scalar(a: *const Scalar) -> Scalar {
    println!("a: {:?}", a);
    if !a.is_null() {
        println!("input not null");
    }
    let mut rng = thread_rng();
    let b = Scalar::random(&mut rng);
    println!("b: {:?}", b);
    return b;
}