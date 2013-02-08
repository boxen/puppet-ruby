# Installs a ruby version via rbenv.
# Takes cc, ensure, global, conf_opts, and version params.
#
# Usage:
#
#     ruby::version { '1.9.3-p194': }
define ruby::version(
  $cc        = '/usr/bin/cc',
  $ensure    = 'installed',
  $global    = false,
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
      command     => "rbenv install ${version}",
      cwd         => "${ruby::root}/versions",
      provider    => 'shell',
      timeout     => 0,
      creates     => $dest
    }

    Exec["ruby-install-${version}"] { environment +> $env }

    if $global {
      file { "${ruby::root}/version":
        ensure  => present,
        owner   => $::luser,
        mode    => '0644',
        content => "${version}\n",
        require => Exec["ruby-install-${version}"]
      }
    }

    ruby::gem {
      "bundler for ${version}":
        gem     => 'bundler',
        ruby    => $version,
        version => '~> 1.2.0';

      "rbenv-autohash for ${version}":
        gem  => 'rbenv-autohash',
        ruby => $version
    }
  }
}
