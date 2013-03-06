# Installs ruby 1.9.2p320 from rbenv and symlinks it as 1.8.7.
#
# Usage:
#
#     include ruby::1_9_2
class ruby::1_9_2 {
  require ruby
  require ruby::1_9_2_p320

  ruby::alias { '1.9.2': target => '1.9.2-p320' }
}
