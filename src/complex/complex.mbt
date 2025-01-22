pub struct Complex {
     real: Double
     imag: Double
} derive (Show, Eq)

pub fn Complex::new(real: Double, imag: Double) -> Complex {
  {real: real, imag: imag}
}


//| Define the addition of two complex numbers.
pub fn op_add(self: Complex, other: Complex) -> Complex {
  Complex::{
    real: self.real + other.real,
    imag: self.imag + other.imag
  }
}

//| multiply two complex numbers.
pub fn op_mul(self: Complex, other: Complex) -> Complex {
  Complex :: {
    real: self.real * other.real - self.imag * other.imag,
    imag: self.real * other.imag + self.imag * other.real
  }
}

//| substract two complex numbers.
pub fn op_sub(self: Complex, other: Complex) -> Complex {
  Complex::{
    real: self.real - other.real,
    imag: self.imag - other.imag
  }
}

//| compute the negative of a complex number.
pub fn op_neg(self: Complex) -> Complex {
  Complex::{
    real: -self.real,
    imag: -self.imag
  }
}

//| divide two complex numbers.
pub fn op_div(self: Complex, other: Complex) -> Complex {
  let denom: Double = other.real * other.real + other.imag * other.imag
  Complex::{
    real: (self.real * other.real + self.imag * other.imag) / denom,
    imag: (self.imag * other.real - self.real * other.imag) / denom
  }
}

///| Calculate the absolute value of a complex number.
pub fn abs(self: Complex) -> Double {
  (self.real * self.real + self.imag * self.imag).sqrt()
}

///| The zero complex number.
pub let zero : Complex = Complex::{real: 0, imag:0}