# (main) canvas_image.tcl

package require Tk
package require Img
# 1.4.10 (Img: to get binary)
set pkg_img 1

set base_dir [file dirname [file normalize [info script]]]
source -encoding utf-8 [file join $base_dir wk/prepare_funcs.tcl]
source -encoding utf-8 [file join $base_dir wk/canvas_tools.tcl]

toplevel .t
wm geometry .t 800x600
wm geometry . 800x600

set f "/prj/Rust/wktk-rs/resource/ruby_200x200.png"
image create photo src -file $f
# src
string bytelength [src cget -file]
# 45
string bytelength [src cget -data]
# 0

image create photo im0
# im0
set img [image create photo]
# image1 (puts $img => image1)
set img2 [image create photo -file $f]
# image2 (puts $img2 => image2)
image create photo img3 -file $f
# img3

string bytelength [im0 cget -file]
# 0
string bytelength [image1 cget -file]
# 0
string bytelength [image2 cget -file]
# 45
string bytelength [img3 cget -file]
# 45

string bytelength [im0 cget -data]
# 0
string bytelength [image1 cget -data]
# 0
string bytelength [image2 cget -data]
# 0
string bytelength [img3 cget -data]
# 0

set dat [src cget -data]
im0 configure -data $dat
string bytelength $dat
# 0

set c [mk_canvas_with_id .t .c0 imtag0 400 300]
# .t.c0

$c create image 200 150 -image im0 -anchor center -tags imtag0
# 1
$c create image 200 150 -image im0 -anchor center -tags imtag0
# 2
$c create image 200 150 -image src -anchor center -tags imtag0
# 3 (shown)
$c delete imtag0
# (no output) (all image removed from canvas $c)

$c create image 200 150 -image im0 -anchor center -tags imtag0
# 4
$c create image 200 150 -image src -anchor center -tags imtag0
# 5 (shown)

$c itemconfigure imtag0 -image src
# (shown)
$c itemconfigure imtag0 -image im0
# (no image shown)
$c itemconfigure imtag0 -image src
# (shown)

if {!$pkg_img} {
# without package Img
  set dat [src data -format png]
# PNG... (output long long data)
  string bytelength [src data -format png]
# 66771
  set encoded [binary encode base64 -maxlen 0 [src data -format png]]
# (base64)
} else {
# with package Img
  set encoded [src data -format png]
  set dat [binary decode base64 $encoded]
# PNG... (output long long data)
  string bytelength $dat
# 66771
  set encoded [binary encode base64 -maxlen 0 $dat]
# (base64)
}
string bytelength $encoded
# 59776
string bytelength [src cget -data]
# 0

$c itemconfigure imtag0 -image im0
# (no image shown)
im0 configure -data $dat
# (shown)
if {!$pkg_img} {
# without package Img
  string bytelength [im0 data -format png]
# 66771
} else {
# with package Img
  string bytelength [binary decode base64 [im0 data -format png]]
# 66771
}
string bytelength [im0 cget -data]
# 66771

$c create image 200 150 -image src -anchor center -tags imtag0
# 6
$c create image 200 150 -image img3 -anchor center -tags imtag0
# 7
$c delete imtag0
# (no output) (all image removed from canvas $c)
$c itemconfigure 7 -image im0
# (no image shown)
$c itemconfigure imtag0 -image img3
# (no image shown)
$c itemconfigure imtag0 -image im0
# (no image shown)
$c create image 200 150 -image img3 -anchor center -tags imtag0
# 8 (shown)
$c itemconfigure imtag0 -image img3
# (shown)
$c create image 200 150 -image img3 -anchor center -tags imtag0
# 9 (shown)

$c delete imtag0
# (no output) (all image removed from canvas $c)
$c create image 200 150 -image image1 -anchor center -tags imtag0
# 10
$c create image 200 150 -image image2 -anchor center -tags imtag0
# 11 (shown)
$c itemconfigure 11 -image image1
# (no image shown)
$c itemconfigure 11 -image image2
# (shown) (layer overlapped)
$c itemconfigure 11 -image image1
# (no image shown)
$c itemconfigure 10 -image image2
# (shown) (layer overlapped)
$c itemconfigure 10 -image image1
# (no image shown)
$c itemconfigure 1 -image image2
# (no image shown)
$c itemconfigure 9 -image image2
# (no image shown)
$c find all
# 10 11
$c delete imtag0
# (no output) (all image removed from canvas $c)
$c find all
# (no output)
$c delete imtag0
# (no output) (no error)
$c create image 200 150 -image image2 -anchor center -tags imtag0
# 12 (shown)
$c create image 200 150 -image image2 -anchor center -tags imtag0
# 13 (shown)
$c find withtag all
# 12 13
$c find withtag imtag0
# 12 13
$c find withtag imtag
# (no output)
puts [get_item_keys $c image imtag0]
# 12 13 (get only image type)
puts [get_image_keys $c image imtag0]
# image2 image2
$c itemconfigure 12 -image src
# (shown)
$c itemconfigure 13 -image $img
# (shown) (layer overlapped)
if {!$pkg_img} {
# without package Img
  string bytelength [$img data -format png]
# 150 (no image)
  string bytelength [$img2 data -format png]
# 66771
  string bytelength [src data -format png]
# 66771
} else {
# with package Img
  #set encoded_img [$img data -format png]
  #set dat_img [binary decode base64 $encoded_img]
  #string bytelength $dat_img
# 150 (no image)
  set encoded_img2 [$img2 data -format png]
  set dat_img2 [binary decode base64 $encoded_img2]
  string bytelength $dat_img2
# 66771
  set encoded_src [src data -format png]
  set dat_src [binary decode base64 $encoded_src]
  string bytelength $dat_src
# 66771
}
puts [get_image_keys $c image]
# src image1
$c delete 12
# (no output) (no image shown) (remove only image 12)
puts [get_image_keys $c image]
# image1
puts [get_item_keys $c image]
# 13 (get only image type)
$c find withtag all
# 13
$c find all
# 13
if {!$pkg_img} {
# without package Img
  $img configure -data $dat
# (shown)
} else {
# with package Img
  $img configure -data [binary encode base64 -maxlen 0 $dat]
# (shown)
}
