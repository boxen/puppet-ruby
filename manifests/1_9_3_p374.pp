# Installs ruby 1.9.3p374 from rbenv.
#
# Usage:
#
#     include ruby::1_9_3_p374

class ruby::1_9_3_p374 {
  ruby::version { '1.9.3-p374': }
}
