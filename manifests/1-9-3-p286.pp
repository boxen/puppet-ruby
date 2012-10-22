# Installs ruby 1.9.3p286 from rbenv.
# Default global ruby version.
#
# Usage:
#
#     include ruby::1-9-3-p286
class ruby::1-9-3-p286 {
  ruby { '1.9.3-p286':
    global => true
  }
}
