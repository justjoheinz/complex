
test "Complex::op_add/basic" {
  let a = Complex::{ real: 1.0, imag: 2.0 }
  let b = Complex::{ real: 3.0, imag: 4.0 }
  let sum = a + b
  inspect!(sum, content="{real: 4, imag: 6}")
}


test "Complex::op_add/zero" {
  let a = Complex::{ real: 1.0, imag: 2.0 }
  let zero = Complex::{ real: 0.0, imag: 0.0 }
  let sum = a + zero
  inspect!(sum, content="{real: 1, imag: 2}")
}

test "Complex::op_add/negative" {
  let a = Complex::{ real: 1.0, imag: 2.0 }
  let neg = Complex::{ real: -1.0, imag: -2.0 }
  let sum = a + neg
  inspect!(sum, content="{real: 0, imag: 0}")
}



test "Complex::op_mul/basic" {
  let a = Complex::{ real: 0.0, imag: -1.0 }
  let product = a * a
  inspect!(product, content="{real: -1, imag: 0}")
}

test "Complex::op_mul/identity" {
  let a = Complex::{ real: 2.0, imag: 3.0 }
  let one = Complex::{ real: 1.0, imag: 0.0 }
  let product = a * one
  inspect!(product, content="{real: 2, imag: 3}")
}

test "Complex::op_mul/zero" {
  let a = Complex::{ real: 2.0, imag: 3.0 }
  let zero = Complex::{ real: 0.0, imag: 0.0 }
  let product = a * zero
  inspect!(product, content="{real: 0, imag: 0}")
}