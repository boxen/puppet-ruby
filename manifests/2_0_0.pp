# Installs ruby 2.0.0-p0 from rbenv and symlinks it as 2.0.0.
#
# Usage:
#
#     include ruby::2_0_0
class ruby::2_0_0 {
  require ruby
  require ruby::2_0_0_p0

  ruby::alias { '2.0.0': target => '2.0.0-p0' }
}
