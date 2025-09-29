///|
/// A complex number with real and imaginary parts.
pub(all) struct Complex {
  real : Double
  imag : Double
} derive(Eq)

///|
pub impl Show for Complex with output(self, logger) {
  let (r, i) = (self.real, self.imag)
  Show::output(r, logger)
  if i < 0 {
    logger.write_char('-')
  } else {
    logger.write_char('+')
  }
  Show::output(i.abs(), logger)
  logger.write_char('i')
}

///|
/// @alert deprecated "Use the structure directly instead"
pub fn Complex::new(real : Double, imag : Double) -> Complex {
  { real, imag }
}

///|
pub impl Add for Complex with add(self, other) {
  Complex::{ real: self.real + other.real, imag: self.imag + other.imag }
}

///|
pub impl Mul for Complex with mul(self, other) {
  Complex::{
    real: self.real * other.real - self.imag * other.imag,
    imag: self.real * other.imag + self.imag * other.real,
  }
}

///|
pub impl Sub for Complex with sub(self, other) {
  Complex::{ real: self.real - other.real, imag: self.imag - other.imag }
}

///|
pub impl Neg for Complex with neg(self) {
  Complex::{ real: -self.real, imag: -self.imag }
}

///|
pub impl Div for Complex with div(self, other) {
  let denom : Double = other.real * other.real + other.imag * other.imag
  Complex::{
    real: (self.real * other.real + self.imag * other.imag) / denom,
    imag: (self.imag * other.real - self.real * other.imag) / denom,
  }
}

///|
/// Calculate the absolute value of a complex number.
pub fn abs(self : Complex) -> Double {
  (self.real * self.real + self.imag * self.imag).sqrt()
}

///|
/// Calculate the conjugate of a complex number
pub fn conjugate(self : Complex) -> Complex {
  Complex::{ real: self.real, imag: -self.imag }
}

///|
pub fn reciprocal(self : Complex) -> Complex {
  let denom : Double = self.real * self.real + self.imag * self.imag
  Complex::{ real: self.real / denom, imag: -self.imag / denom }
}

///|
/// The zero complex number.
pub let zero : Complex = { real: 0, imag: 0 }
