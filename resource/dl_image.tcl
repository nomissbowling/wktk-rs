# (main) dl_image.tcl

set base_dir [file dirname [file normalize [info script]]]
source -encoding utf-8 [file join $base_dir net/dl_https.tcl]
source -encoding utf-8 [file join $base_dir wk/prepare_funcs.tcl]
source -encoding utf-8 [file join $base_dir wk/canvas_toplevel.tcl]

# namespace eval my_namespace {
#   proc hoge {} {
#     ...
#   }
# }

wm geometry . 800x600
set l0 [canvas_toplevel . .cv .lbl im0 400 300]

toplevel .t
wm geometry .t 800x600
set tl [canvas_toplevel .t .cv .lbl tim 400 300]

set uri "https://files.catbox.moe/riqo8l.png"
puts [set_img_uri $l0 im0 $uri]
puts [set_img_uri $tl tim $uri]
