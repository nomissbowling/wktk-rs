# delete objects and children of toplevel t: . or .hoge
proc reset_all {t} {
  destroy {*}[winfo children $t]
  foreach id [after info] { after cancel $id }
  # if {$imgxx in [image names]} { image delete $imgxx }
  image delete {*}[image names]
  # if {$fontxx in [font names]} { font delete $fontxx }
  ### *** caution *** delete all system fonts
  # font delete {*}[font names]
  ### safely
  foreach f [font names] { if {![string match {Tk*} $f]} { font delete $f } }
}

# delete namespace to_be_deleted: ::app_namespace
proc reset_namespace {to_be_deleted} {
  if {[namespace exists $to_be_deleted]} { namespace delete $to_be_deleted }
}
