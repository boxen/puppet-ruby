class ruby::chruby(
  $ensure = $ruby::chruby::ensure,
  $prefix = $ruby::chruby::prefix,
  $user   = $ruby::chruby::user,
) {

  require ruby

  repository { $prefix:
    ensure => $ensure,
    force  => true,
    source => 'postmodern/chruby',
    user   => $user
  }

}
