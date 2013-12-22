# Installs the latest Ruby 2.1.0 from upstream.
#
# Usage:
#
#     include ruby::2_1_0
class ruby::2_1_0 {
  require ruby
  require ruby::2_1_0_preview2

  file { "${ruby::rbenv_root}/versions/2.1.0":
    ensure  => symlink,
    force   => true,
    target  => "${ruby::rbenv_root}/versions/2.1.0-preview2"
  }
}
