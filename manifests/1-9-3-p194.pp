# Installs ruby 1.9.3p193 from rbenv.
# Default global ruby version.
#
# Usage:
#
#     include ruby::1-9-3-p194
class ruby::1-9-3-p194 {
  ruby { '1.9.3-p194':
    global => true
  }
}
