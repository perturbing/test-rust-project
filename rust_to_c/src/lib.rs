use std::mem::transmute;
use blstrs::Scalar;
use ff::Field;
use rand::thread_rng;

#[no_mangle]
pub extern "C" fn random_scalar(a: *mut Scalar) -> Scalar {
    let ptr_as_usize: usize = unsafe { transmute(a) };
    println!("Pointer as usize: {:#x}", ptr_as_usize);

    if a.is_null() {
        println!("Received null pointer!");
        return Scalar::ZERO;
    } else {
        unsafe {
            let scalar_value = *a;
            println!("Received scalar: {:?}", scalar_value);
        }
    }

    let mut rng = thread_rng();
    let b = Scalar::random(&mut rng);
    println!("Generated random scalar: {:?}", b);
    return b;
}
