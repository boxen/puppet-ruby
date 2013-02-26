# Installs ruby 2.0.0-p0 from rbenv and symlinks it as 2.0.0.
#
# Usage:
#
#     include ruby::2_0_0
class ruby::2_0_0 {
  require ruby
  require ruby::2_0_0_p0

  file { "${ruby::root}/versions/2.0.0":
    ensure  => symlink,
    force   => true,
    target  => "${ruby::root}/versions/2.0.0-p0"
  }
}

