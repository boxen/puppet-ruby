# Public: specify the global ruby version as per rbenv
#
# Usage:
#
#   class { 'ruby::global': version => '1.9.3' }

class ruby::global($version = '1.9.3') {
  if $version != 'system' {
    require join(['ruby', join(split($version, '[.-]'), '_')], '::')
  }

  file { "${ruby::root}/version":
    ensure  => present,
    owner   => $::boxen_user,
    mode    => '0644',
    content => "${version}\n",
  }
}