# Installs ruby 1.8.7p358 from rbenv.
# On 10.8 disables tk, tcl, and tcltk.
#
# Usage:
#
#     include ruby::1_8_7_p358
class ruby::1_8_7_p358 {
  $opts = $::macosx_productversion_major ? {
    '10.8'  => '--disable-tk --disable-tcl --disable-tcltk-framework',
    default => undef
  }

  ruby::version { '1.8.7-p358':
    cc        => '/usr/local/bin/gcc-4.2',
    conf_opts => $opts,
  }
}
