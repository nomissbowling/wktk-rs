//! wk
//!

use crate::core::*;
use rstk::*;

use std::{result::Result, error::Error};

/// downloader
/// - likes resource/dl_image.tcl
pub fn downloader(lbl: &str, im: &str, uri: &str) ->
  Result<(), Box<dyn Error>> {
  let l = ask_safely(&format!("set_img_uri {} {} {{{}}}", lbl, im, uri));
  println!("length: {}", l);
  Ok(())
}

/// canvas_toplevel
pub fn canvas_toplevel(rt: &TkTopLevel, cv: &str, cl: &str, im: &str,
  sz: (u64, u64)) -> String {
  ask_safely(&format!("canvas_toplevel {} {} {} {} {} {}",
    rt.id(), cv, cl, im, sz.0, sz.1))
}

/// topmost
pub fn topmost(w: &TkTopLevel) -> Result<(), Box<dyn Error>> {
  let c = format!("wm attributes {0} -topmost 1; raise {0}; focus -force {0}",
    w.id());
  rstk::tell_wish(&c);
  Ok(())
}

/// mk_id
pub fn mk_id(t: &str) -> String {
  format!(".{}", t.replace(" ", "_"))
}

/// mk_with_checked_id
pub fn mk_with_checked_id(w: &str, p: &impl TkWidget, id: &str) -> String {
  let wid = if id.starts_with(".") { id }
    else { eprintln!("{} id forget [.]{}", w, id); &format!(".{}", id) };
  ask_safely(&format!("{} [idchild {} {}]", w, p.id(), wid))
}

/// mk_toplevel_with_id
pub fn mk_toplevel_with_id(p: &impl TkWidget, id: &str) -> TkTopLevel {
  TkTopLevel{id: mk_with_checked_id("toplevel", p, id)}
}

/// mk_frame_with_id
pub fn mk_frame_with_id(p: &impl TkWidget, id: &str) -> TkFrame {
  TkFrame{id: mk_with_checked_id("ttk::frame", p, id)}
}

/// mk_button_with_id
pub fn mk_button_with_id(p: &impl TkWidget, id: &str) -> TkButton {
  TkButton{id: mk_with_checked_id("ttk::button", p, id)}
}

/// mk_label_with_id
pub fn mk_label_with_id(p: &impl TkWidget, id: &str) -> TkLabel {
  TkLabel{id: mk_with_checked_id("ttk::label", p, id)}
}
