# Manage ruby versions with chruby.
#
# Usage:
#
#     include ruby::chruby
#
# Normally internal use only; will be automatically included by the `ruby` class
# if `ruby::provider` is set to "chruby"

class ruby::chruby(
  $ensure      = $ruby::chruby::ensure,
  $prefix      = $ruby::chruby::prefix,
  $user        = $ruby::chruby::user,
  $auto_switch = $ruby::chruby::auto_switch,
) {
  require ruby

  repository { $prefix:
    ensure => $ensure,
    force  => true,
    source => 'postmodern/chruby',
    user   => $user
  }
}
