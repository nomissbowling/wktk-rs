package require Tk
package require http
package require tls

::http::register https 443 [list ::tls::socket -autoservername true]

proc dl_https {uri} {
  set token [::http::geturl $uri]
  set dat [::http::data $token]
  ::http::cleanup $token
  return $dat
}

proc set_img_uri {lbl img uri} {
  $lbl configure -text $uri
  return [set_img_dat $img [dl_https $uri]]
}

proc set_img_dat {img dat} {
  $img configure -data $dat
  return [string bytelength $dat]
}
