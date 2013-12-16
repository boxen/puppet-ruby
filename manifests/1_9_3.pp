# Installs ruby 1.9.3-p484 from rbenv and symlinks it as 1.9.3.
#
# Usage:
#
#     include ruby::1_9_3
class ruby::1_9_3 {
  ruby::version { '1.9.3': }
}
