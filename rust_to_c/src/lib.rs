use blstrs::Scalar;

#[no_mangle]
pub extern "C" fn double(a: Scalar) -> Scalar {
    return a + a
}