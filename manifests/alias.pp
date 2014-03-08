define ruby::alias(
  $to      = undef,
  $version = $title,
) {

  require ruby

  if $to == undef {
    fail("to cannot be undefined")
  }

  ensure_resource('ruby::version', $to)

  file { "${ruby::prefix}/rubies/${version}":
    ensure  => symlink,
    force   => true,
    target  => "${ruby::prefix}/rubies/${to}",
    require => Ruby::Version[$to],
  }



}
