# Public: Install an rbenv plugin
#
# Usage:
#
#   ruby::plugin { 'rbenv-vars':
#     ensure => 'v1.2.0',
#     source => 'sstephenson/rbenv-vars'
#   }

define ruby::plugin($ensure, $source) {
  include ruby

  repository { "${ruby::rbenv_root}/plugins/${name}":
    ensure => $ensure,
    force  => true,
    source => $source,
    user   => $ruby::user
  }
}
