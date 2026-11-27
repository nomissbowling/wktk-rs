# encoding for wish console (to open file dialog as [source -encoding utf-8])

# define for console
console eval {
  # define globals on console
  set ::filetypes_source {{{Tcl Scripts} {.tcl}} {{All Files} *}}
  set ::open_file_title {Select a file to source UTF-8}

  # sync globals to wish (must separate from define proc)
  consoleinterp eval [list set ::filetypes_source $::filetypes_source]
  consoleinterp eval [list set ::open_file_title $::open_file_title]

  # override top menu (source) for console (open file and run on console)
  proc tk::ConsoleSource {} {
    global ::filetypes_source ::open_file_title
    set file [tk_getOpenFile -parent . -title $::open_file_title \
      -filetypes $::filetypes_source]
    if {$file ne {}} { uplevel #0 [list source -encoding utf-8 $file] }
  }

  # define for wish
  consoleinterp eval {
    # open dialog (open file and run on wish)
    proc open_and_source_utf8 {} {
      global ::filetypes_source ::open_file_title
      set file [tk_getOpenFile -parent . -title $::open_file_title \
        -filetypes $::filetypes_source]
      if {$file ne {}} { source -encoding utf-8 $file }
    }
  }
}

# memo: *** Must not execute ***
if 0 {
  ### ---- wish to console
  # on wish: var on wish
  set shared_var "from wish"
  # on wish: var to console
  console eval [list set shared_var $shared_var]
  # on wish: val from console
  set val [console eval {set shared_var}]

  ### ---- console to wish
  # on console: set ver on wish
  consoleinterp eval [list set shared_var "from console"]

  ### ---- auto sync by trace
  # on wish: (to sync val realtime)
  set ::shared_var "Initial Value"
  console eval [list set ::shared_var $::shared_var]
  # trace: auto sync wish to console
  trace add variable ::shared_var write {apply {{name1 name2 op} {
    console eval [list set ::shared_var $::shared_var]
  }}}
  # trace: auto sync console to wish
  console eval {
    trace add variable ::shared_var write {apply {{name1 name2 op} {
      # exec only when val changed to avoid infinite loop
      if {[consoleinterp eval {set ::shared_var}] ne $::shared_var} {
        consoleinterp eval [list set ::shared_var $::shared_var]
      }
    }}}
  }

  ### on unix: simply global *** tk console does not exist on unix terminal ***
  global shared_var
}
