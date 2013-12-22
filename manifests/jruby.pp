# Installs jruby 1.7.6 from rbenv and symlinks it as jruby.
#
# Usage:
#
#     include ruby::jruby
class ruby::jruby {
  require ruby
  require ruby::jruby_1_7_6

  file { "${ruby::rbenv_root}/versions/jruby":
    ensure  => symlink,
    force   => true,
    target  => "${ruby::rbenv_root}/versions/jruby-1.7.6"
  }
}
