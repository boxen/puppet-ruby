# Installs a rubygem for a specific version of ruby managed by chruby.
#
# Usage:
#
#     ruby::gem { 'bundler for 1.9.3-p194':
#       gem     => 'bundler',
#       ruby    => '1.9.3-p194',
#       version => '~> 1.2.0'
#     }
define ruby::gem($gem, $ruby, $ensure = 'present', $version = '>= 0') {
  require ruby

  if $ruby != 'system' and $ensure == present {
    $klass = join(['ruby', join(split($ruby, '[.-]'), '_')], '::')
    require $klass
  }

  chruby_gem { $name:
    ensure       => $ensure,
    gem          => $gem,
    version      => $version,
    chruby_root  => $ruby::chruby_root,
    ruby_version => $ruby,
  }
}
