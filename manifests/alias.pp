# Aliases a (usually shorter) ruby version to another
#
# Usage:
#
#     ruby::alias { '1.9.3': to => '2.0.0-p594' }

define ruby::alias(
  $ensure  = 'installed',
  $to      = undef,
  $version = $title,
) {

  require ruby

  if $to == undef {
    fail('to cannot be undefined')
  }

  if $ensure != 'absent' {
    ensure_resource('ruby::version', $to)
  }

  $file_ensure = $ensure ? {
    /^(installed|present)$/ => 'symlink',
    default                 => $ensure,
  }

  file { "/opt/rubies/${version}":
    ensure  => $file_ensure,
    force   => true,
    target  => "/opt/rubies/${to}",
    require => Ruby::Version[$to],
  }
}
