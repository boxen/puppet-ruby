# Installs a ruby version via rbenv.
# Takes cc, ensure, conf_opts, and version params.
#
# Usage:
#
#     ruby::version { '1.9.3-p194': }

define ruby::version(
  $ensure      = 'installed',
  $environment = undef,
  $conf_opts   = undef,
  $version     = $name
) {
  require ruby

  rbenv_ruby { $version:
    ensure      => $ensure,
    conf_opts   => $conf_opts,
    environment => $environment,
    rbenv_root  => $ruby::root,
  }

  Ruby::Gem {
    ruby => $version
  }

  ruby::gem {
    "bundler for ${version}":
      gem     => 'bundler',
      version => '~> 1.3.0';

    "rbenv-autohash for ${version}":
      gem  => 'rbenv-autohash' ;
  }
}
