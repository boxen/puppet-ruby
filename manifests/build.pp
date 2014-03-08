class ruby::build(
  $ensure = $ruby::build::ensure,
  $prefix = $ruby::build::prefix,
  $user   = $ruby::build::user,
) {

  require ruby

  repository { $prefix:
    ensure => $ensure,
    force  => true,
    source => 'sstephenson/ruby-build',
    user   => $user,
  }

}
