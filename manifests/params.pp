# Public: Configuration values for ruby
class ruby::params {
  case $::osfamily {
    'Darwin': {
      include boxen::config

      $rbenv_root = "${boxen::config::home}/rbenv"
      $user       = $::boxen_user
    }

    default: {
      $rbenv_root = '/usr/local/share/rbenv'
      $user       = 'root'
    }
  }

  $rbenv_version = 'v0.4.0'

  $default_gems = ['bundler ~>1.3']

  $rbenv_plugins = {
    'ruby-build' => {
      'ensure' => 'v20130628',
      'source' => 'sstephenson/ruby-build'
    },
    'rbenv-gem-rehash' => {
      'ensure' => 'v1.0.0',
      'source' => 'sstephenson/rbenv-gem-rehash'
    },
    'rbenv-default-gems' => {
      'ensure' => 'v1.0.0',
      'source' => 'sstephenson/rbenv-default-gems'
    }
  }
}
