# Installs ruby 1.9.2p320 from rbenv and symlinks it as 1.8.7.
#
# Usage:
#
#     include ruby::1_9_2
class ruby::1_9_2 {
  ruby::version { '1.9.2': }
}
