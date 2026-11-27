set script_dir [file dirname [file normalize [info script]]]
source -encoding utf-8 [file join $script_dir ../wk/canvas_tools.tcl]

proc canvas_toplevel {id cv cl im w h} {
  set lbl [idchild $id $cl]
  # set img [image create photo $im -data $dat]
  set img [image create photo $im]
  # set img [image create photo]
  ##label $lbl -image $img -text {sample} -compound bottom
  ##place $lbl -relx 0.5 -rely 0.5 -anchor center
  # pack $lbl -expand 1
  # grid $lbl
  # grid $lbl -row 0 -column 0
  # grid rowconfigure $id 0 -weight 1
  # grid columnconfigure $id 0 -weight 1
  # $lbl configure -image $img
  # $lbl configure -image {}

  label $lbl -text {sample}
  place $lbl -relx 0.3 -rely 0.0
  set tg {imtag0}
  set c [mk_canvas_with_id $id $cv $tg $w $h]
  set cw [expr {$w / 2}]
  set ch [expr {$h / 2}]
  $c create image $cw $ch -image $img -anchor center -tags $tg
  place $c -relx 0.2 -rely 0.2
  return $lbl
}
