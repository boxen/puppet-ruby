# Installs ruby 1.9.3p286 from rbenv.
#
# Usage:
#
#     include ruby::1-9-3-p286

class ruby::1_9_3_p286 {
  ruby::version { '1.9.3-p286': }
}
