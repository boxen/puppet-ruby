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

}
