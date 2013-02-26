# Installs ruby 1.8.7p358 from rbenv.
# On 10.8 disables tk, tcl, and tcltk.
#
# Usage:
#
#     include ruby::1-8-7-p358
class ruby::1-8-7-p358 {
  ruby::version { '1.8.7-p358':
    conf_opts => $conf_opts,
  }
}
