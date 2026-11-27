proc get_item_keys {c ty {tg all}} {
  set ids {}
  foreach id [$c find withtag $tg] {
    if {[$c type $id] eq $ty} { lappend ids $id }
  }
  return $ids
}

proc get_image_keys {c ty {tg all}} {
  set ids [get_item_keys $c $ty $tg]
  set keys {}
  foreach id $ids { lappend keys [$c itemcget $id -image] }
  return $keys
}

proc on_canvas_resized {c tg w h} {
  set keys [get_image_keys $c image $tg]
  set k [expr {[llength $keys] > 0 ? [lindex $keys 0] : {unknown}}]
  set cx [expr {$w / 2}]
  set cy [expr {$h / 2}]
  $c delete $tg
  $c create image $cx $cy -image $k -anchor center -tags $tg
}

proc mk_canvas_with_id {p id tg w h} {
  set c [canvas [idchild $p $id] -width $w -height $h]
  pack $c -fill both -expand 1
  bind $c <Configure> [list on_canvas_resized $c $tg %w %h]
  return $c
}
