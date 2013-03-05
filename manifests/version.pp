# Installs a ruby version via rbenv.
# Takes cc, ensure, conf_opts, and version params.
#
# Usage:
#
#     ruby::version { '1.9.3-p194': }

define ruby::version(
  $cc        = '/usr/bin/cc',
  $ensure    = 'installed',
  $conf_opts = undef,
  $version   = $name
) {
  require ruby

  $dest = "${ruby::root}/versions/${version}"

  if $ensure == 'absent' {
    file { $dest:
      ensure => absent,
      force  => true
    }
  } else {
    $env = $conf_opts ? {
      undef   => [
        "CC=${cc}",
        "RBENV_ROOT=${ruby::root}"
      ],
      default => [
        "CC=${cc}",
        "RBENV_ROOT=${ruby::root}",
        "CONFIGURE_OPTS=${conf_opts}"
      ],
    }

    exec { "ruby-install-${version}":
      command     => "${ruby::root}/bin/rbenv install ${version}",
      cwd         => "${ruby::root}/versions",
      provider    => 'shell',
      timeout     => 0,
      creates     => $dest
    }

    Exec["ruby-install-${version}"] { environment +> $env }

    ruby::gem {
      "bundler for ${version}":
        gem     => 'bundler',
        ruby    => $version,
        version => '~> 1.3';

      "rbenv-autohash for ${version}":
        gem  => 'rbenv-autohash',
        ruby => $version
    }
  }
}
