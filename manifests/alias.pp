# Public: Sets up an alias for $name to the rbenv version for $target.
#
# Usage:
#
#   ruby::alias { '1.9.3': target => '1.9.3-p392' }

define ruby::alias($target) {
  require ruby

  file { "${ruby::root}/versions/${name}":
    ensure  => symlink,
    force   => true,
    target  => "${ruby::root}/versions/${target}"
  }
}
