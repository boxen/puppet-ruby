# Installs a ruby version via ruby-build.
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

  include homebrew::config

  case $::operatingsystem {
    'Darwin': {
      require xquartz

      $os_env = {
        'CFLAGS'      => '-I/opt/X11/include',
        'PATH'        => "${homebrew::config::installdir}/bin:${ruby::chruby_root}/bin:${ruby::rubybuild_root}/bin:/usr/bin",
        'CHRUBY_ROOT' => @resource[:chruby_root],
      }
    }

    default: {
      $os_env = {}
    }
  }

  $dest = "${ruby::chruby_root}/versions/${version}"

  if $ensure == 'absent' {
    file { $dest:
      ensure => absent,
      force  => true
    }
  } else {
    $default_env = {
      'CC' => '/usr/bin/cc',
    }

    $final_env = merge(merge($default_env, $os_env), $env)

    exec { "ruby-build-${version}":
      command     => "${ruby::chruby_root}/bin/chruby-install ${version}",
      cwd         => "${ruby::chruby_root}/versions",
      provider    => 'shell',
      timeout     => 0,
      creates     => $dest,
      user        => $ruby::user,
    }
    ->
    ruby::gem { "bundler for ${version}":
      gem     => 'bundler',
      ruby    => $version,
      version => '~> 1.0'
    }

    Exec["ruby-build-${version}"] {
      environment +> sort(join_keys_to_values($final_env, '='))
    }
  }
}
