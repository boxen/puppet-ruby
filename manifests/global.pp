# Public: specify the global ruby version as per rbenv
#
# Usage:
#
#   class { 'ruby::global': version => '1.9.3' }

class ruby::global($version = '1.9.3') {
  require ruby

  if $version != 'system' {
   $klass = join(['ruby', join(split($version, '[.-]'), '_')], '::')
   require $klass
  }

  boxen::env_script { 'default_ruby_version':
    ensure   => present,
    content  => "chruby ${version}\n",
    priority => 'lowest',
  }
}
