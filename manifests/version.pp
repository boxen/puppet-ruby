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

  case $::operatingsystem {
    'Darwin': {
      require xquartz
      include homebrew::config

      $os_env = {
        'CFLAGS'      => "-I${homebrew::config::installdir}/include -I/opt/X11/include",
        'LDFLAGS'     => "-L${homebrew::config::installdir}/lib -L/opt/X11/lib",
        'PATH'        => "${homebrew::config::installdir}/bin:${ruby::chruby_root}/bin:${ruby::rubybuild_root}/bin:/usr/bin:/bin",
        'CHRUBY_ROOT' => $ruby::chruby_root,
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
      command     => "/bin/rm -rf ${dest} && ${ruby::chruby_root}/bin/chruby-install ${version}",
      cwd         => "${ruby::chruby_root}/versions",
      provider    => 'shell',
      timeout     => 0,
      creates     => "${dest}/bin/ruby",
      user        => $ruby::user,
    }

    ->
    chruby_gem { "bundler for ${version}":
      gem          => 'bundler',
      version      => '~> 1.3',
      ruby_version => $version,
      chruby_root  => $ruby::chruby_root,
    }

    Exec["ruby-build-${version}"] {
      environment +> sort(join_keys_to_values($final_env, '='))
    }
  }
}
