use blstrs::Scalar;
use ff::Field;
use rand::thread_rng;

type ScalarPtr = *mut Scalar;

#[no_mangle]
pub extern "C" fn random_scalar(a: *mut ScalarPtr) -> Scalar {
    unsafe {
        if let Some(a_ref) = a.as_mut() {
            if !(*a_ref).is_null() {
                println!("Pointer is valid, proceeding with random scalar generation.");
                println!("Current value of a: {:?}", **a_ref);
            } else {
                println!("Pointer is valid, but the pointed-to Scalar is null.");
            }

            let mut rng = thread_rng();
            let b = Scalar::random(&mut rng);
            println!("Generated random scalar: {:?}", b);

            *a_ref = Box::into_raw(Box::new(b));
            b // Return the generated Scalar
        } else {
            println!("Received null pointer!");
            Scalar::ZERO // Return a default zero Scalar in case of error
        }
    }
}
