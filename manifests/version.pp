# Installs a ruby version with ruby-build..
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

  $alias_hash = hiera_hash('ruby::version::alias', {})

  if has_key($alias_hash, $version) {
    $to = $alias_hash[$version]

    ruby::alias { $version:
      to => $to,
    }
  } else {

    case $version {
      /jruby/: { require 'java' }
      default: { }
    }

    case $::osfamily {
      'Darwin': {
        require xquartz
        include homebrew::config
        include boxen::config

        $os_env = {
          'BOXEN_S3_HOST'   => $::boxen_s3_host,
          'BOXEN_S3_BUCKET' => $::boxen_s3_bucket,
          'CFLAGS'          => "-I${homebrew::config::installdir}/include -I/opt/X11/include",
          'LDFLAGS'         => "-L${homebrew::config::installdir}/lib -L/opt/X11/lib",
        }
      }

      default: {
        $os_env = {}
      }
    }

    $default_env = {
      'CC' => '/usr/bin/cc',
    }

    $hierdata = hiera_hash('ruby::version::env', {})
    if has_key($hierdata, $version) {
      $hiera_env = $hierdata[$version]
    } else {
      $hiera_env = {}
    }

    $final_env = merge(merge(merge($default_env, $os_env), $hiera_env), $env)

    if has_key($final_env, 'CC') {
      case $final_env['CC'] {
        /gcc/:   { require gcc }
        default: { }
      }
    }

    ensure_resource('file', "${ruby::prefix}/rubies", {
      'ensure' => 'directory',
      'owner'  => $user,
    })

    ruby { $version:
      ensure      => $ensure,
      environment => $final_env,
      prefix      => "${ruby::prefix}/rubies/${version}",
      ruby_build  => "${ruby::prefix}/ruby-build/bin/ruby-build",
      user        => $ruby::user,
      provider    => rubybuild,
    }

  }

}
