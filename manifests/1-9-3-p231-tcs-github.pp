# Installs ruby 1.9.3-p231-tcs-github from rbenv.
# Default global ruby version.
#
# Usage:
#
#     include ruby::1-9-3-p231-tcs-github

class ruby::1-9-3-p231-tcs-github {
  ruby::definition { '1.9.3-p231-tcs-github': }
  ruby::version    { '1.9.3-p231-tcs-github':
    global => true
  }
}
