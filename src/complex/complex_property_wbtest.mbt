// Property-based tests for Complex arithmetic, using
// `moonbitlang/core/quickcheck`.
//
// See https://www.moonbitlang.com/blog/property-based-testing-moonbit for the
// underlying ideas. Instead of hand-picking a few example inputs, we state
// algebraic *laws* that must hold for *every* complex number and let
// quickcheck generate hundreds of random cases (and shrink any failure down to
// a minimal counterexample).
//
// This is a whitebox test file (`_wbtest.mbt`): it lives inside the `complex`
// package, so the `Arbitrary` / `Shrink` / `Debug` instances below are visible
// only to the test build and never become dependencies of the published
// library.

// ---------------------------------------------------------------------------
// Making `Complex` generatable
// ---------------------------------------------------------------------------

///|
/// A random `Complex`. The built-in `Double` generator only yields values in
/// `[0, 1)`, which would trap every sample in the first quadrant. We remap it
/// to a symmetric `[-span, span]` range so signs and all four quadrants are
/// exercised — this is the "generators encode domain insight" point from the
/// blog post.
impl @quickcheck.Arbitrary for Complex with fn arbitrary(_size, rs) {
  let span = 100.0
  fn coord() {
    (rs.next_double() * 2.0 - 1.0) * span
  }

  { real: coord(), imag: coord() }
}

///|
/// Shrinking: when a property fails, reduce the counterexample toward simpler
/// values by shrinking each component independently (a product-type shrink).
impl @shrink.Shrink for Complex with fn shrink(self) {
  let { real, imag } = self
  @shrink.Shrink::shrink(real)
  .map(r => Complex::{ real: r, imag })
  .concat(@shrink.Shrink::shrink(imag).map(i => Complex::{ real, imag: i }))
}

///|
/// `Debug` is required by `@quickcheck.check` so failing inputs can be printed.
impl @debug.Debug for Complex with fn to_repr(self) {
  @debug.Repr::Repr(self.to_string())
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

///|
let one : Complex = { real: 1.0, imag: 0.0 }

///|
/// Relative tolerance for approximate comparisons: two values may differ by
/// this fraction of their magnitude. Floating-point arithmetic is not
/// associative/distributive to the last bit, so laws that round are checked to
/// within this tolerance rather than with `==`.
let rel_tol : Double = 1.0e-9

///|
/// Absolute tolerance. Needed because a purely relative test never lets a
/// non-zero result be "close" to zero (`0.is_close(1e-30)` is `false`), so
/// laws whose result can cancel to ~0 (e.g. `conjugate(a) * a` imaginary part)
/// need a small absolute floor.
let abs_tol : Double = 1.0e-9

///|
/// Minimum modulus an input must have to take part in division/reciprocal
/// properties. Values closer to zero make the reciprocal blow up and lose all
/// precision, so they are filtered out.
let min_magnitude : Double = 1.0e-3

///|
/// Approximate equality for reals, delegating to the core `Double::is_close`
/// (PEP 485 / Python's `math.isclose`).
fn close_d(a : Double, b : Double) -> Bool {
  a.is_close(b, relative_tolerance=rel_tol, absolute_tolerance=abs_tol)
}

///|
/// Approximate equality for complex numbers: both components must be close.
fn close(x : Complex, y : Complex) -> Bool {
  close_d(x.real, y.real) && close_d(x.imag, y.imag)
}

// ---------------------------------------------------------------------------
// Exact laws — these hold bit-for-bit, so we can use `==`
// ---------------------------------------------------------------------------

///|
/// The property the request asked for: subtracting a value from itself is the
/// zero complex number, for every `a`.
test "prop: a - a == zero" {
  @quickcheck.check((a : Complex) => a - a == zero, count=1000)
}

///|
/// Addition is commutative. (IEEE addition is exactly commutative, so `==`.)
test "prop: a + b == b + a" {
  @quickcheck.check((p : (Complex, Complex)) => {
    let (a, b) = p
    a + b == b + a
  })
}

///|
/// `zero` is the additive identity.
test "prop: a + zero == a" {
  @quickcheck.check((a : Complex) => a + zero == a && zero + a == a)
}

///|
/// Every element has an additive inverse.
test "prop: a + (-a) == zero" {
  @quickcheck.check((a : Complex) => a + -a == zero)
}

///|
/// Negation is an involution.
test "prop: -(-a) == a" {
  @quickcheck.check((a : Complex) => -(-a) == a)
}

///|
/// Multiplication is commutative.
test "prop: a * b == b * a" {
  @quickcheck.check((p : (Complex, Complex)) => {
    let (a, b) = p
    a * b == b * a
  })
}

///|
/// `one` is the multiplicative identity.
test "prop: a * one == a" {
  @quickcheck.check((a : Complex) => a * one == a && one * a == a)
}

///|
/// Conjugation is an involution.
test "prop: conjugate(conjugate(a)) == a" {
  @quickcheck.check((a : Complex) => a.conjugate().conjugate() == a)
}

///|
/// Conjugation distributes over addition.
test "prop: conjugate(a + b) == conjugate(a) + conjugate(b)" {
  @quickcheck.check((p : (Complex, Complex)) => {
    let (a, b) = p
    (a + b).conjugate() == a.conjugate() + b.conjugate()
  })
}

///|
/// `abs` is invariant under conjugation and negation (same squared components).
test "prop: abs(conjugate(a)) == abs(a) and abs(-a) == abs(a)" {
  @quickcheck.check((a : Complex) => {
    a.conjugate().abs() == a.abs() && (-a).abs() == a.abs()
  })
}

// ---------------------------------------------------------------------------
// Approximate laws — rounding means we compare up to a tolerance
// ---------------------------------------------------------------------------

///|
/// Addition is associative (up to rounding).
test "prop: (a + b) + c ~= a + (b + c)" {
  @quickcheck.check((t : (Complex, Complex, Complex)) => {
    let (a, b, c) = t
    close(a + b + c, a + (b + c))
  })
}

///|
/// Multiplication is associative (up to rounding).
test "prop: (a * b) * c ~= a * (b * c)" {
  @quickcheck.check((t : (Complex, Complex, Complex)) => {
    let (a, b, c) = t
    close(a * b * c, a * (b * c))
  })
}

///|
/// Multiplication distributes over addition (up to rounding).
test "prop: a * (b + c) ~= a * b + a * c" {
  @quickcheck.check((t : (Complex, Complex, Complex)) => {
    let (a, b, c) = t
    close(a * (b + c), a * b + a * c)
  })
}

///|
/// The modulus is multiplicative: |a * b| == |a| * |b|.
test "prop: abs(a * b) ~= abs(a) * abs(b)" {
  @quickcheck.check((p : (Complex, Complex)) => {
    let (a, b) = p
    close_d((a * b).abs(), a.abs() * b.abs())
  })
}

///|
/// `conjugate(a) * a` is real and equals `|a|^2`.
test "prop: conjugate(a) * a ~= (|a|^2, 0)" {
  @quickcheck.check((a : Complex) => {
    let prod = a.conjugate() * a
    close(prod, { real: a.abs() * a.abs(), imag: 0.0 })
  })
}

///|
/// `reciprocal` is a two-sided multiplicative inverse. Near-zero inputs are
/// filtered out because their reciprocal blows up and loses all precision.
test "prop: a * reciprocal(a) ~= one" {
  @quickcheck.check((a : Complex) => close(a * a.reciprocal(), one), filter=a => {
    a.abs() > min_magnitude
  })
}

///|
/// Division undoes multiplication: (a * b) / b == a.
test "prop: (a * b) / b ~= a" {
  @quickcheck.check(
    (p : (Complex, Complex)) => {
      let (a, b) = p
      close(a * b / b, a)
    },
    filter=p => {
      let (_, b) = p
      b.abs() > min_magnitude
    },
  )
}
