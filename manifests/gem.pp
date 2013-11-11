# Installs a rubygem for a specific version of ruby managed by chruby.
#
# Usage:
#
#     ruby::gem { 'bundler for 1.9.3-p194':
#       gem    => 'bundler',
#       ruby   => '1.9.3-p194',
#       ensure => '1.3.5'
#     }
define ruby::gem($gem, $ruby, $ensure = 'present',) {
  require ruby

  if $ruby == undef or $ruby == 'undef' {
    fail('Must pass a valid ruby version for the gem!')
  }

  if $ruby != 'system' and $ensure == present {
    $klass = join(['ruby', join(split($ruby, '[.-]'), '_')], '::')
    include $klass
  }

  gem { $name:
    ensure    => $ensure,
    gem       => $gem,
    ruby_root => "${ruby::chruby_root}/versions/${ruby}",
    require   => Class["${klass}"],

    provider  => chruby,
  }
}
