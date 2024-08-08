use blstrs::Scalar;
use ff::Field;
use rand::thread_rng;

#[no_mangle]
pub extern "C" fn double(a: Scalar) -> Scalar {
    let mut rng = thread_rng();
    return Scalar::random(&mut rng);
}