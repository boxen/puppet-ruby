# Installs ruby 1.8.7p358 from rbenv.
# On 10.8 disables tk, tcl, and tcltk.
#
# Usage:
#
#     include ruby::1_8_7_p358
class ruby::1_8_7_p358 {
  require gcc

  $default_env = {
    'CC' => '/opt/boxen/homebrew/bin/gcc-4.2'
  }

  if $::macosx_productversion_major == '10.8' {
    $env = merge($default_env, {
      'CONFIGURE_OPTS' => '--disable-tk --disable-tcl --disable-tcltk-framework'
    })
  } else {
    $env = $default_env
  }

  ruby::version { '1.8.7-p358':
    env => $env
  }
}
