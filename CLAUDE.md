# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a MoonBit library for complex number arithmetic operations. The library provides a `Complex` struct with real and imaginary parts, implementing standard mathematical operations (addition, subtraction, multiplication, division) and utility functions (abs, conjugate, reciprocal).

## Build Commands

- `moon build` - Build the library
- `moon test` - Run all tests
- `moon test -p complex` - Run tests for the complex package specifically
- `moon test -f src/complex/complex-test.mbt` - Run tests from a specific file
- `moon fmt` - Format source code
- `moon fmt --check` - Check formatting without modifying files
- `moon check` - Type check without building object files
- `moon clean` - Remove target directory

## Architecture

The codebase follows MoonBit's module structure:

- `src/complex/` - Main package containing the Complex type and operations
  - `complex.mbt` - Core Complex struct and trait implementations
  - `complex-test.mbt` - Unit tests using MoonBit's testing framework
  - `moon.pkg.json` - Package configuration (currently empty)

The `Complex` type is defined as a struct with `real` and `imag` fields of type `Double`. Key architectural decisions:

- Implements standard Rust-like traits: `Add`, `Sub`, `Mul`, `Div`, `Neg`, `Show`, `Eq`
- Uses MoonBit's derive mechanism for `Eq` trait
- Custom `Show` implementation formats numbers as "a+bi" or "a-bi"
- All operations are implemented as pure functions with no side effects

## Testing

Tests use MoonBit's built-in testing framework with `inspect()` for assertions. Test naming follows the pattern `"StructName::method/case"`. To run a single test by index: `moon test -i <index>`.

## Package Management

This is a published MoonBit package (`justjoheinz/complex`) that can be installed via `moon add justjoheinz/complex`. The project uses semantic versioning and is currently at version 0.4.1.