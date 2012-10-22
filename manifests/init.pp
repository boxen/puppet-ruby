# Installs a ruby version via rbenv.
# Takes cc, ensure, global, conf_opts, and version params.
#
# Usage:
#
#     ruby { '1.9.3-p194': }
define ruby($cc        = '/usr/bin/cc',
            $ensure    = 'installed',
            $global    = false,
            $conf_opts = undef,
            $version   = $name) {

  require rbenv

  $dest = "${rbenv::root}/versions/${version}"

  if $ensure == 'absent' {
    file { $dest:
      ensure => absent,
      force  => true
    }
  } else {
    if $conf_opts == undef {
      $env = ["CC=${cc}", "RBENV_ROOT=${rbenv::root}"]
    } else {
      $env = [
              "CC=${cc}",
              "RBENV_ROOT=${rbenv::root}",
              "CONFIGURE_OPTS=${conf_opts}"
              ]
    }


    exec { "ruby-install-${version}":
      command     => "rbenv install ${version}",
      cwd         => "${rbenv::root}/versions",
      environment => $env,
      provider    => 'shell',
      require     => [Package['rbenv'], File["${rbenv::root}/versions"]],
      returns     => [0, 1], # FIX: rbenv boog: $? is 1 on successful install
      timeout     => 0,
      creates     => $dest
    }

    if $global {
      file { "${rbenv::root}/version":
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
