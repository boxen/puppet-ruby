# Installs a ruby version via rbenv.
# Takes ensure, env, and version params.
#
# Usage:
#
#     ruby::version { '1.9.3-p194': }

define ruby::version(
  $ensure  = 'installed',
  $env     = {},
  $version = $name
) {
  require ruby

  $dest = "${ruby::root}/versions/${version}"

  if $ensure == 'absent' {
    file { $dest:
      ensure => absent,
      force  => true
    }
  } else {
    $default_env = {
      'CC'         => '/usr/bin/cc',
      'RBENV_ROOT' => $ruby::root
    }

    exec { "ruby-install-${version}":
      command     => "${ruby::root}/bin/rbenv install ${version}",
      cwd         => "${ruby::root}/versions",
      provider    => 'shell',
      timeout     => 0,
      creates     => $dest
    }

    Exec["ruby-install-${version}"] {
      environment +> sort(join_keys_to_values(merge($default_env, $env), '='))
    }

    ruby::gem {
      "bundler for ${version}":
        gem     => 'bundler',
        ruby    => $version,
        version => '~> 1.3';

      "rbenv-autohash for ${version}":
        ensure => absent,
        gem    => 'rbenv-autohash',
        ruby   => $version
    }
  }
}
