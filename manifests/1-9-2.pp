# Installs ruby 1.9.2p320 from rbenv and symlinks it as 1.8.7.
#
# Usage:
#
#     include ruby::1-9-2
class ruby::1-9-2 {
  require ruby::1-9-2-p320

  file { "${rbenv::root}/versions/1.9.2":
    ensure  => symlink,
    force   => true,
    target  => "${rbenv::root}/versions/1.9.2-p320"
  }
}
