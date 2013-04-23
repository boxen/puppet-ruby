# Public: Install an rbenv plugin
#
# Usage:
#
#   ruby::plugin { 'rbenv-vars':
#     version => 'v1.2.0',
#     source  => 'sstephenson/rbenv-vars'
#   }

define ruby::plugin($version, $source) {
  include ruby

  $fetch    = 'git fetch --quiet origin'
  $reset    = "git reset --hard ${version}"
  $describe = 'git describe --tags --exact-match `git rev-parse HEAD`'

  repository { "${ruby::root}/plugins/${name}":
    source  => $source,
    extra   => "-b '${version}'",
    require => File["${ruby::root}/plugins"]
  }

  exec { "ensure-${name}-version-${version}":
    command => "${fetch} && ${reset}",
    unless  => "${describe} | grep ${version}",
    cwd     => "${ruby::root}/plugins/${name}",
    require => Repository["${ruby::root}/plugins/${name}"],
  }
}
