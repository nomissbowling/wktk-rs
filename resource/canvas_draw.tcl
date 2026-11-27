package require Tk
package require Img
# 1.4.10 (Img: to get binary)

# on console: open from top menu (source) (open this file)
# on wish: execute open_and_source_utf8 (open this file)

# (search_proc will not be found on console: defined on wish)
# set search_proc {::open_and_source_utf8}
# set found_proc [expr {$search_proc in [info procs $search_proc] ? 1 : 0}]
# set found_proc [expr {[namespace which -command $search_proc] ne {}}]
set found_proc [info exists ::open_file_title]
if {!$found_proc} {
  puts {first [source set_file_encoding.tcl]; second [open_and_source_utf8]}
  flush stdout
  # after 10000 [...]
  # gets stdin
  return
}

# replace console (must before consoleinterp record)
wm geometry . +600+450

# re-open as on wish when open from top menu (source)
if {[info commands consoleinterp] ne {}} {
  consoleinterp record [list source -encoding utf-8 [info script]]
  return
}

# replace wish
wm geometry . 400x300+200+150

set base_dir [file dirname [file normalize [info script]]]
source -encoding utf-8 [file join $base_dir reset_all.tcl]

# check re-execute by winfo
if {[winfo exists .c]} {
  .c delete all
  destroy .c
  reset_all .
}

# set fam [font families]
# (output fonts) (long long output)

canvas .c -width 400 -height 300 -bg "#87CEEB"
pack .c

# define font named (family will be converted to Unicode string in PostScript)
# non-proportional (fixed-width) (monoscaped): Courier, MS Gothic
# Linux: Noto Color Emoji
# MacOS: Apple Color Emoji
# Windows: Segoe UI Emoji, Windings
font create SunFont -family "Arial" -size 60 -weight bold
font create TreeFont -family "Segoe UI Emoji" -size 50
font create TextFont -family "Meiryo" -size 16
# draw SUN
.c create text 320 60 -text "☀" -font SunFont -fill "#FF4500"
# draw SNOW TREE HOUSE
.c create text 100 70 -text "☁" -font {Arial 55} -fill white
.c create text 100 220 -text "🌲" -font TreeFont -fill "#228B22"
.c create text 160 225 -text "🏠" -font TreeFont -fill "#8B4513"
# draw TERRAIN
.c create rectangle 0 250 400 300 -fill "#32CD32" -outline {}
# draw CAPTION
.c create text 200 275 -text "drawing by fonts" -font TextFont -fill white
# draw POLYGON
set vtx {220 40 270 80 250 140 190 140 170 80}
.c create polygon $vtx -fill yellow -outline brown -width 2 -tags {plytag0}
.c create polygon $vtx -fill salmon -outline red -width 2 -smooth 1 -dash {4 2} -tags {plytag1}
.c create polygon 80 180 130 80 180 180 -fill lightgreen -outline darkgreen -width 2 -tags {plytag2}
.c create polygon 80 180 130 80 180 180 -fill aqua -outline navy -width 2 -smooth 1 -dash {4 2} -tags {plytag3}
.c create oval 220 150 380 250 -fill lime -outline magenta -width 3
.c create text 300 200 -text {Tcl/Tk} -font {Helvetica 16 bold} -fill green

# AA {MS PGothic} (12pt / 16px)
set fnt [font create AAFont -family {MS PGothic} -size 12]
set aa {　　　 ∧＿∧\n　　 （　´∀｀）\n　　 （　　　　）\n　　 ｜ ｜　|\n　　 （_＿）＿）}
# set aa [regsub -all {(\\n)} $aa "\n"]
set aa [string map {{\n} "\n"} $aa]
# must -anchor nw -justify left (default: -anchor center -justify center)
.c create text 8 8 -text $aa -font $fnt -anchor nw -justify left -fill black

# built-in
# get text as PostScript (sometimes can not output fonts transparency subwin)
set ps_text [.c postscript -colormode color]
# as Unicode string (long long output)
# convert to utf-8 binary (still PostScript) convert by Ghostscript ImageMagick
set binary_ps [encoding convertto utf-8 $ps_text]
# as utf-8 (long long output)

# must need update before capture
update
# capture
set img [image create photo {captag0} -format window -data .c]
# as b64 (long long output)
set base64_data [$img data -format png]
# as bin (long long output)
set binary_data [binary decode base64 $base64_data]
# hex: get 8 bytes signature x89PNGx0dx0ax1ax0a
binary scan [string range $binary_data 0 7] H* hex
puts "PNG Header: $hex"
# PNG Header: 89504e470d0a1a0a
# release memory
image delete $img
