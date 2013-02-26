# Installs ruby 1.9.2-p320 via rbenv.
#
# Usage:
#
#     include ruby::1_9_2_p320
class ruby::1_9_2_p320 {
  ruby::version { '1.9.2-p320':
    cc      => '/usr/local/bin/gcc-4.2',
  }
}
