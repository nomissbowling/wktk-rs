proc idwrt {id} {
  # return [if {$id eq {.}} { expr {""} } else { expr {$id} }]
  return [string trimright $id {.}]
}

proc idchild {id c} {
  set w [idwrt $id]
  return [expr {"${w}${c}"}]
}

proc wm_size {id w h} {
  wm withdraw $id
  wm geometry $id ${w}x${h}
  update idletasks
  wm deiconify $id
  return [wm geometry $id]
}

proc wm_loc {id p} {
  lassign [wm_get_wh $id] w h
  return [wm_sizeloc $id $w $h $p]
}

proc wm_sizeloc {id w h p} {
  lassign [wm_get_scwh $id] scw sch
  set gw [wm_calcloc $p w $w $scw]
  set gh [wm_calcloc $p h $h $sch]
  wm geometry $id ${w}x${h}+${gw}+${gh}
  return [list $w $h $gw $gh $scw $sch]
}

proc wm_calcloc {p q s t} {
  set d [expr {$t - $s}]
  return [
    if {$p eq {center}} { expr {$d / 2}
    } elseif {$p eq {lt}} { expr {0}
    } elseif {$p eq {rt}} { if {$q eq {w}} { expr {$d} } else { expr {0} }
    } elseif {$p eq {lb}} { if {$q eq {h}} { expr {$d} } else { expr {0} }
    } elseif {$p eq {rb}} { expr {$d}
    } else { expr {$d / 2} }
  ]
}

proc wm_get_wh {id} {
  return [list [winfo width $id] [winfo height $id]]
}

proc wm_get_scwh {id} {
  return [list [winfo screenwidth $id] [winfo screenheight $id]]
}
