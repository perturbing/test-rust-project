use blstrs::Scalar;
use ff::Field;
use rand::thread_rng;

#[no_mangle]
pub extern "C" fn random_scalar(a: *mut Scalar) -> Scalar {
    println!("a: {:?}", a);
    let mut rng = thread_rng();
    let b = Scalar::random(&mut rng);
    println!("b: {:?}", b);
    return b;
}