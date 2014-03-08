define ruby::alias(
  $to      = undef,
  $version = $title,
) {

  require ruby

  if $to == undef {
    fail("to cannot be undefined")
  }

  ensure_resource('ruby::version', $to)

  file { "/opt/rubies/${version}":
    ensure  => symlink,
    force   => true,
    target  => "/opt/rubies/${to}",
    require => Ruby::Version[$to],
  }



}
