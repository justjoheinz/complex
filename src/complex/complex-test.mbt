test "Complex::op_add/basic" {
  let a = { real: 1.0, imag: 2.0 }
  let b = { real: 3.0, imag: 4.0 }
  let sum = a + b
  inspect!(sum, content="4+6i")
}

test "Complex::op_add/zero" {
  let a = { real: 1.0, imag: 2.0 }
  let zero = { real: 0.0, imag: 0.0 }
  let sum = a + zero
  inspect!(sum, content="1+2i")
}

test "Complex::op_add/negative" {
  let a = { real: 1.0, imag: 2.0 }
  let neg = { real: -1.0, imag: -2.0 }
  let sum = a + neg
  inspect!(sum, content="0+0i")
}

test "Complex::op_mul/basic" {
  let a = { real: 0.0, imag: -1.0 }
  let product = a * a
  inspect!(product, content="-1+0i")
}

test "Complex::op_mul/identity" {
  let a = { real: 2.0, imag: 3.0 }
  let one = { real: 1.0, imag: 0.0 }
  let product = a * one
  inspect!(product, content="2+3i")
}

test "Complex::op_mul/zero" {
  let a = { real: 2.0, imag: 3.0 }
  let zero = { real: 0.0, imag: 0.0 }
  let product = a * zero
  inspect!(product, content="0+0i")
}


///|
test "Complex::Show/basic" {
  let z = Complex::{ real: 3.2, imag: 4.5 }
  inspect!(z, content=
    "3.2+4.5i"
  )
  let w = Complex::{ real: -2.2, imag: 5.3 }
  inspect!(w, content=
    "-2.2+5.3i"
  )
}

///|
test "Complex::Show/negative_imag" {
  let z = Complex::{ real: 1.0, imag: -2.0 }
  inspect!(z, content="1-2i")
  let w = Complex::{ real: -3.0, imag: -4.0 }
  inspect!(w, content="-3-4i")
}

///|
test "Complex::Show/zero" {
  let z = Complex::{ real: 0.0, imag: 0.0 }
  inspect!(z, content="0+0i")
  let w = Complex::{ real: 1.0, imag: 0.0 }
  inspect!(w, content="1+0i")
  let v = Complex::{ real: 0.0, imag: 1.0 }
  inspect!(v, content="0+1i")
}


test "Complex::to_string" {
  let a :Complex = { real: 1.0, imag: 2.0 }
  let s = a.to_string()
  inspect!(s, content="1+2i")
}
