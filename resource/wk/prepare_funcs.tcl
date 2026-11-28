proc idwrt {id} {
  # return [if {$id eq {.}} { expr {""} } else { expr {$id} }]
  return [string trimright $id {.}]
}

proc idchild {id c} {
  set w [idwrt $id]
  return [expr {"${w}${c}"}]
}

proc num_suffix {str} {
  if {[regexp {^(.*?)(\d+)$} $str -> prefix num]} {
    scan $num %d val ;# scan as decimal to avoid fetch 0NNN as octal number
    return [list $val $num $prefix]
  } else {
    return [list]
  }
}

proc increment_suffix {str pad} {
  set lst [num_suffix $str]
  if {[llength $lst] > 0} {
    lassign $lst val num prefix
    incr val
    set len [string length $num]
    if {$pad} { set val [format "%0${len}d" $val] }
    return "${prefix}${val}"
  } else {
    return "${str}_1"
  }
}

if 0 {
  # set new_history_id [history nextid] ;# number of command
  # set new_id [increment_suffix [lindex [winfo children .] end] 1]
  puts [increment_suffix "item_9" 0]   ;# item_10
  puts [increment_suffix "test005" 0]  ;# test6
  puts [increment_suffix "sample" 0]   ;# sample1
  puts [increment_suffix "item_009" 1] ;# item_010
  puts [increment_suffix "item_099" 1] ;# item_100
  puts [increment_suffix "file_1" 1]   ;# file_2
}

proc mk_id_from_last_child {id} {
  set s [lindex [winfo children $id] end]
  set lst [num_suffix $s]
  set n [expr { [llength $lst] > 0 ? [lindex $lst 0] : 0 }]
  incr n
  return [list [increment_suffix $s 1] $n]
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
