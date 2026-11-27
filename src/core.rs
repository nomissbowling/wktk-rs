//! core
//!

use crate::wk::{self, TkPlaceLayout};
use rstk::*;

use std::{result::Result, error::Error};

/// wish_toplevel
pub fn wish_toplevel(w: u64, h: u64) -> Result<TkTopLevel, Box<dyn Error>> {
  rstk::start_wish().map_or(
    Err("Can not start wish. Tcl/Tk is not installed ?".into()),
    |rt| { // place toplevel root window to right bottom (no care multi screen)
/*
      let scw = ask_safely("winfo screenwidth .").parse::<u64>()?;
      let sch = ask_safely("winfo screenheight .").parse::<u64>()?;
      rt.geometry(w, h, (scw - w).try_into()?, (sch - h).try_into()?);
*/
      sources(None, "resource", vec![
        "net/dl_https.tcl", "wk/prepare_funcs.tcl", "wk/canvas_toplevel.tcl",
        "etc/custom.tcl"]);
      let scwh = ask_safely(&format!("wm_sizeloc {} {} {} rb", rt.id(), w, h));
      println!("desktop: {}", scwh);
      let _fql = wk::canvas_toplevel(&rt, ".cv", ".lbl", "center", (w, h));
      Ok(rt)
    }
  )
}

/// sources
/// - cwd: (None: env TCL_WKTK or current) or Some(cwd)
/// - p: middle path to sources
/// - srcs: vec sources
pub fn sources(cwd: Option<&str>, p: &str, srcs: Vec<&str>) {
  let wd = cwd.map_or_else(|| std::env::var("TCL_WKTK").map_or_else(|_err| {
    ask_safely("set current [file dirname [file normalize [info script]]]");
    "$current".into()
  }, |tcl_wktk| tcl_wktk), |wd| wd.into());
  srcs.into_iter().for_each(|src| {
    rstk::tell_wish(&format!(
      "source -encoding utf-8 [file join {} {} {}]", wd, p, src));
  });
}

/// ask_safely
pub fn ask_safely(q: &str) -> String {
  // rstk::ask_wish(&q) // not flushed (catch another output)
  rstk::ask_wish(&format!("puts [{}]; flush stdout", q)) // safely
}

/// ask_bin_safely (as base64 encoded)
pub fn ask_bin_safely(q: &str) -> String {
  ask_safely(&format!("binary encode base64 -maxlen 0 [{}]", q))
}

/// ask_safely_test (to_string_lossy broken when binary: must encode base64)
pub fn ask_safely_test() -> Result<(), Box<dyn Error>> {
  let tcl = "binary format c* {72 101 108 108 111 0 255}";
/*
  let s = ask_safely(tcl);
  // assert_eq!(s, "Hello\x00\xff"); // outof range (can not compile)
  assert_eq!(s.as_bytes(), b"Hello\x00\xff"); // not match at \xff
*/
  let e = ask_bin_safely(tcl);
  assert_eq!(e, "SGVsbG8A/w=="); // base64 encoded 'Hello\x00\xff'
  Ok(())
}

/// rstk_test
pub fn rstk_test(rt: &TkTopLevel, t: &str) -> Result<(), Box<dyn Error>> {
  let w = wk::mk_toplevel_with_id(rt, &wk::mk_id(t));
  w.title(t);
  let ((x, y), sz) = ((200, 150), (800, 600));
  // re-position before first geometry
  let (x, y) = if t.ends_with("test") { (x / 2, y / 2) } else { (x, y) };
  w.geometry(sz.0, sz.1, x, y);
  // re-set size after first geometry
  let z = if t.ends_with("test") { (sz.0 / 2, sz.1 / 2) } else { sz };
/*
  rstk::tell_wish(&format!("wm geometry {} {}x{}", w.id(), z.0, z.1)); // +x+y
  rstk::tell_wish("update idletasks"); // force change geometry to ask_wish
  let g = ask_safely(&format!("wm geometry {}", w.id()));
*/
  let g = ask_safely(&format!("wm_size {} {} {}", w.id(), z.0, z.1));
  println!("geometry: {} {} {}", g, w.id(), t);

  let p = if t.ends_with("lib") { "center" }
    else { if t.ends_with("test") { "lb" } else { "rt" } };

  // w before move
  let uri = "https://files.catbox.moe/riqo8l.png";
  let fql = wk::canvas_toplevel(&w, ".cv", ".lbl", p, (sz.0 / 2, sz.1 / 2));
  assert_eq!(wk::downloader(&fql, p, uri)?, ());

  let btn = wk::mk_button_with_id(&w, ".mybtn");
  btn.text(p);
  btn.place(4, 4); // btn.grid().layout();
  let lbl = wk::mk_label_with_id(&w, ".mylbl");
  lbl.text(t);
  lbl.place_configure("-relx 0.1 -rely 0.0"); // lbl.grid().layout();

//  let title = t.to_string(); // to keep lifetime (used w finialy before move)
  btn.clone().command(move || { // must clone btn before move
/*
    let g = ask_safely(&format!("wm_loc {} {}", w.id(), btn.cget("text")));
    println!("geometry: {} {} {}", g, w.id(), title);
*/
    let g = ask_safely(&format!("on_btn_clicked {} {}", btn.id(), w.id()));
    println!("geometry: {}", g);
  });

  Ok(())
}

/// lib_test
pub fn lib_test() -> Result<(), Box<dyn Error>> {
  let rt = wish_toplevel(320, 240)?;
  assert_eq!(ask_safely_test()?, ());
  assert_eq!(rstk_test(&rt, "test lib")?, ());
  wk::topmost(&rt)?;
  rstk::mainloop();
  Ok(())
}
