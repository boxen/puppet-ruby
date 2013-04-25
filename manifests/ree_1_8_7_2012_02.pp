# Public: Install ree-1.8.7-2012.02 via rbenv.
#
# Usage:
#
#   include ree_1_8_7_2012_02

class ruby::ree_1_8_7_2012_02 {
  require gcc
  require xquartz

  ruby::version { 'ree-1.8.7-2012.02':
    env => {
      'CC'       => '/opt/boxen/homebrew/bin/gcc-4.2',
      'CPPFLAGS' => '-I/opt/X11/include',
    }
  }
}
