# Installs ruby 1.8.7p358 from rbenv and symlinks it as 1.8.7.
#
# Usage:
#
#     include ruby::1_8_7
class ruby::1_8_7 {
  ruby::version { '1.8.7': }
}
