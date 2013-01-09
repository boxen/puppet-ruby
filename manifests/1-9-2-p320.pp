# Installs ruby 1.9.2-p320 via rbenv.
#
# Usage:
#
#     include ruby::1-9-2-p320
class ruby::1-9-2-p320 {
  ruby::version { '1.9.2-p320':
    cc      => '/usr/local/bin/gcc-4.2',
    require => Package['boxen/brews/apple-gcc42']
  }
}
