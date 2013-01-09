# Installs ruby 1.9.3-p362 from rbenv and symlinks it as 1.9.3.
#
# Usage:
#
#     include ruby::1-9-3
class ruby::1-9-3 {
  require ruby::1-9-3-p362

  file { "${rbenv::root}/versions/1.9.3":
    ensure  => symlink,
    force   => true,
    target  => "${rbenv::root}/versions/1.9.3-p362"
  }
}
