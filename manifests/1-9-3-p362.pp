# Installs ruby 1.9.3p362 from rbenv.
# Default global ruby version.
#
# Usage:
#
#     include ruby::1-9-3-p362

class ruby::1-9-3-p362 {
  ruby { '1.9.3-p362':
    global => true
  }
}
