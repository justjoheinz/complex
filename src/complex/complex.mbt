///| A complex number with real and imaginary parts.
pub(all) struct Complex {
  real : Double
  imag : Double
} derive(Show, Eq)

///| @alert deprecated "Use the structure directly instead"
pub fn Complex::new(real : Double, imag : Double) -> Complex {
  { real, imag }
}

///| Define the addition of two complex numbers.
pub fn op_add(self : Complex, other : Complex) -> Complex {
  Complex::{ real: self.real + other.real, imag: self.imag + other.imag }
}

///| multiply two complex numbers.
pub fn op_mul(self : Complex, other : Complex) -> Complex {
  Complex::{
    real: self.real * other.real - self.imag * other.imag,
    imag: self.real * other.imag + self.imag * other.real,
  }
}

///| substract two complex numbers.
pub fn op_sub(self : Complex, other : Complex) -> Complex {
  Complex::{ real: self.real - other.real, imag: self.imag - other.imag }
}

///| compute the negative of a complex number.
pub fn op_neg(self : Complex) -> Complex {
  Complex::{ real: -self.real, imag: -self.imag }
}

///| divide two complex numbers.
pub fn op_div(self : Complex, other : Complex) -> Complex {
  let denom : Double = other.real * other.real + other.imag * other.imag
  Complex::{
    real: (self.real * other.real + self.imag * other.imag) / denom,
    imag: (self.imag * other.real - self.real * other.imag) / denom,
  }
}

///| Calculate the absolute value of a complex number.
pub fn abs(self : Complex) -> Double {
  (self.real * self.real + self.imag * self.imag).sqrt()
}

///| Calculate the conjugate of a complex number
pub fn conjugate(self : Complex) -> Complex {
  Complex::{ real: self.real, imag: -self.imag }
}

///|
pub fn reciprocal(self : Complex) -> Complex {
  let denom : Double = self.real * self.real + self.imag * self.imag
  Complex::{ real: self.real / denom, imag: -self.imag / denom }
}

///| The zero complex number.
pub let zero : Complex = { real: 0, imag: 0 }
