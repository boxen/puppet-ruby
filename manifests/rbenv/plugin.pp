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

    $plugins_dir_params =  {
      ensure  => directory,
      require => Repository[$ruby::rbenv::prefix]
    }
    ensure_resource('file', "${ruby::rbenv::prefix}/plugins", $plugins_dir_params)

    repository { "${ruby::rbenv::prefix}/plugins/${name}":
      ensure  => $ensure,
      force   => true,
      source  => $source,
      user    => $ruby::user,
      require => File["${ruby::rbenv::prefix}/plugins"]
    }
  }
}
