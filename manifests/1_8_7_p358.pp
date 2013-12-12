# Installs ruby 1.8.7p358 from rbenv.
# On 10.8 disables tk, tcl, and tcltk.
#
# Usage:
#
#     include ruby::1_8_7_p358
class ruby::1_8_7_p358 {
  require gcc

  ruby::version { '1.8.7-p358': }
}
