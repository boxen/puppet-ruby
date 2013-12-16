# Installs ruby 2.0.0-p353 from rbenv and symlinks it as 2.0.0.
#
# Usage:
#
#     include ruby::2_0_0
class ruby::2_0_0 {
  ruby::version { '2.0.0': }
}

