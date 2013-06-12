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

  if $::operatingsystem == 'Darwin' {
    require xquartz
  }

  $dest = "${ruby::rbenv_root}/versions/${version}"

  if $ensure == 'absent' {
    file { $dest:
      ensure => absent,
      force  => true
    }
  } else {
    $default_env = {
      'CC'         => '/usr/bin/cc',
      'RBENV_ROOT' => $ruby::rbenv_root
    }

    $os_env = $::operatingsystem ? {
      'Darwin' => {
        'CFLAGS' => '-I/opt/X11/include'
      },

      default => {}
    }

    $final_env = merge(merge($default_env, $os_env), $env)

    exec { "ruby-install-${version}":
      command     => "${ruby::rbenv_root}/bin/rbenv install ${version}",
      cwd         => "${ruby::rbenv_root}/versions",
      provider    => 'shell',
      timeout     => 0,
      creates     => $dest,
      user        => $ruby::user,
    }

    Exec["ruby-install-${version}"] {
      environment +> sort(join_keys_to_values($final_env, '='))
    }
  }
}
