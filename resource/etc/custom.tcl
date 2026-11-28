proc on_btn_clicked {bid id} {
  set nb [new_btn $id {my button} [list {on_btn_clicked} $bid $id]]
  return [list [wm_loc $id [$bid cget -text]] $id [wm title $id] $nb]
}

proc new_btn {id t c} {
  global num
  # set bid [idchild $id ".mybtn_$num"]
  lassign [mk_id_from_last_child $id] bid n ;# get id .mylbl_NNN
  # (or Rust) rstk::wish::next_wid(parent: &str) -> String
  ttk::button $bid -text [expr {"${t}_$n"}] -command $c
  # must match append style pack/grid on the parent
  # pack $bid -padx 10 -pady 10
  # grid $bid -column 0 -padx 10 -pady 10
  place $bid -x [expr {6 * $n + 16}] -y [expr {4 * $n + 16}]
  set num [expr {$num + 1}]
  return $bid
}

set num 0
