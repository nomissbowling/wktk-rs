//! wktk
//!
//! Cargo test with [-- --nocapture] or with [-- --show-output]
//!
//! - cargo test --bin wktk --release -- --nocapture
//! - cargo test --bin wktk --release -- --show-output
//! - cargo run --bin wktk --release
//! - cargo build --bin wktk --release
//!

use wktk::core::*;

use std::{result::Result, error::Error};

/// main
pub fn main() -> Result<(), Box<dyn Error>> {
  Ok(())
}

/// wktk test
pub fn wktk_test(rt: &rstk::TkTopLevel) -> Result<(), Box<dyn Error>> {
  assert_eq!(rstk_test(rt, "test wktk test")?, ()); // same as lib
  Ok(())
}

/// test with [-- --nocapture] or [-- --show-output]
#[cfg(test)]
mod tests {
  use std::{result::Result, error::Error};
  use wktk::{core::*, wk}; // lib
  use crate::*; // main

  /// test wktk
  #[test]
  fn test_wktk() -> Result<(), Box<dyn Error>> {
    let rt = wish_toplevel(640, 480)?;
    assert_eq!(rstk_test(&rt, "test wktk")?, ()); // same as lib
    assert_eq!(wktk_test(&rt)?, ());
    wk::topmost(&rt)?;
    rstk::mainloop();
    Ok(())
  }
}
