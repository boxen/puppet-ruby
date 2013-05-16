# Public: Install ree-1.8.7-2012.02 via rbenv.
#
# Usage:
#
#   include ree_1_8_7_2012_02

class ruby::ree_1_8_7_2012_02 {
  require gcc
  require xquartz

  case $::osfamily {
    Darwin: {
      include boxen::config

      $env = {
        'CC'       => "${boxen::config::home}/homebrew/bin/gcc-4.2",
        'CPPFLAGS' => '-I/opt/X11/include',
      }
    }

    default: {
      $env = {
        'CC' => 'gcc'
      }
    }
  }

  ruby::version { 'ree-1.8.7-2012.02':
    env => $env
  }
}
