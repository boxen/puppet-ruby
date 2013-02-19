# Installs a rubygem for a specific version of ruby managed by rbenv.
#
# Usage:
#
#     ruby::gem { 'bundler for 1.9.3-p194':
#       gem     => 'bundler',
#       ruby    => '1.9.3-p194',
#       version => '~> 1.2.0'
#     }
define ruby::gem($gem, $ruby, $version = '>= 0') {
  require ruby

  rbenv_gem { $name:
    gem           => $gem,
    version       => $version,
    rbenv_root    => $ruby::root,
    rbenv_version => $ruby,
  }
}
