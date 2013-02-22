# Installs ruby 2.0.0-rc2 from rbenv and symlinks it as 2.0.0.
#
# Usage:
#
#     include ruby::2-0-0
class ruby::2-0-0 {
  require ruby
  require ruby::2-0-0-rc2

  file { "${ruby::root}/versions/2.0.0":
    ensure  => symlink,
    force   => true,
    target  => "${ruby::root}/versions/2.0.0-rc2"
  }
}

