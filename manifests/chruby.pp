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
