# Public: Install an rbenv plugin
#
# Usage:
#
#   ruby::rbenv::plugin { 'rbenv-vars':
#     ensure => 'v1.2.0',
#     source => 'sstephenson/rbenv-vars'
#   }

define ruby::rbenv::plugin($ensure, $source) {
  require ruby

  if $ruby::provider == 'rbenv' {
    repository { "${ruby::rbenv::prefix}/plugins/${name}":
      ensure  => $ensure,
      force   => true,
      source  => $source,
      user    => $ruby::user,
      require => File["${ruby::rbenv::prefix}/plugins"]
    }
  }
}
