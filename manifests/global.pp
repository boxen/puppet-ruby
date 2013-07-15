# Public: specify the global ruby version as per rbenv
#
# Usage:
#
#   class { 'ruby::global': version => '1.9.3' }

class ruby::global($version = '1.9.3') {
  include ruby

  if $version != 'system' {
    $klass = join(['ruby', join(split($version, '[.-]'), '_')], '::')
    require $klass
  }

  file { "${ruby::rbenv_root}/version":
    ensure  => present,
    owner   => $ruby::user,
    mode    => '0644',
    content => "${version}\n",
  }
}
