use blstrs::Scalar;
use ff::Field;
use rand::thread_rng;
use std::slice;

#[no_mangle]
pub extern "C" fn random_scalar_list(scalars_ptr: *mut Scalar, len: usize) {
    println!("Pointer address received in Rust: {:p}", scalars_ptr);

    if !scalars_ptr.is_null() {
        // Convert the raw pointer to a mutable slice
        println!("Received length: {}", len);
        let scalars: &mut [Scalar] = unsafe { slice::from_raw_parts_mut(scalars_ptr, len) };
        for scalar in scalars.iter_mut() {
            println!("Received scalar: {:?}", scalar);
        }
        
        // let mut rng = thread_rng();

        // Modify each scalar in the slice
        // for scalar in scalars.iter_mut() {
            // *scalar = Scalar::random(&mut rng);
            // println!("Modified scalar: {:?}", scalar);
        // }
    } else {
        println!("Received null pointer!");
    }
}
