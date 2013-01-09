# Installs ruby 1.8.7p358 from rbenv and symlinks it as 1.8.7.
#
# Usage:
#
#     include ruby::1-8-7
class ruby::1-8-7 {
  require ruby
  require ruby::1-8-7-p358

  file { "${ruby::root}/versions/1.8.7":
    ensure  => symlink,
    force   => true,
    target  => "${ruby::root}/versions/1.8.7-p358"
  }
}
