use blstrs::Scalar;
use ff::Field;
use rand::thread_rng;

#[no_mangle]
pub extern "C" fn random_scalar(a: *mut Scalar) -> Scalar {
    // Log the pointer address Rust is receiving for 'a'
    println!("Pointer address received in Rust: {:p}", &a);

    if a.is_null() {
        println!("Received null pointer!");
        // Handle the null case, perhaps by returning a default value or by error handling
        return Scalar::ZERO; // Returning a default scalar, you might choose to handle it differently
    } else {
        unsafe {
            // Dereference the pointer to inspect the Scalar
            let scalar_value = *a;
            println!("Received scalar: {:?}", scalar_value);
        }
    }

    let mut rng = thread_rng();
    let b = Scalar::random(&mut rng);
    println!("Generated random scalar: {:?}", b);
    return b;
}
