use blstrs::Scalar;
use ff::Field;
use rand::thread_rng;

#[no_mangle]
pub extern "C" fn random_scalar(a: *mut u8) -> Scalar {
    // println!("Pointer address received in Rust: {:p}", a);

    let scalar: &mut Scalar = unsafe { &mut *(a as *mut Scalar) };
    println!("a : {:?}", scalar);

    let mut rng = thread_rng();
    *scalar = Scalar::random(&mut rng);
    
    println!("Generated random scalar: {:?}", *scalar);
    
    *scalar
}
