# Installs ruby 1.9.3-p392 from rbenv and symlinks it as 1.9.3.
#
# Usage:
#
#     include ruby::1_9_3
class ruby::1_9_3 {
  require ruby
  require ruby::1_9_3_p392

  file { "${ruby::root}/versions/1.9.3":
    ensure  => symlink,
    force   => true,
    target  => "${ruby::root}/versions/1.9.3-p392"
  }
}
