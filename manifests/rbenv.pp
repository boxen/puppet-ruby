# Manage ruby versions with rbenv.
#
# Usage:
#
#     include ruby::rbenv
#
# Normally internal use only; will be automatically included by the `ruby` class
# if `ruby::provider` is set to "rbenv"

class ruby::rbenv(
  $ensure = $ruby::rbenv::ensure,
  $prefix = $ruby::rbenv::prefix,
  $user   = $ruby::rbenv::user,
) {

  require ruby

  repository { $prefix:
    ensure => $ensure,
    force  => true,
    source => 'sstephenson/rbenv',
    user   => $user
  }

  file { "${prefix}/versions":
    ensure  => symlink,
    force   => true,
    backup  => false,
    target  => '/opt/rubies',
    require => Repository[$prefix],
  }

}
