# Installs ruby 1.9.2-p290 via rbenv.
#
# Usage:
#
#     include ruby::1_9_2_p290
class ruby::1_9_2_p290 {
  require gcc

  ruby::version { '1.9.2-p290':
    env => {
      'CC' => '/opt/boxen/homebrew/bin/gcc-4.2'
    }
  }
}
