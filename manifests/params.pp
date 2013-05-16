class ruby::params {
  case $::osfamily {
    'Darwin': {
      include boxen::config

      $rbenv_root = "${boxen::config::home}/rbenv"
    },

    default: {
      $rbenv_root = '/usr/local/share/rbenv'
    }
  }

  $rbenv_version = 'v0.4.0',

  $default_gems = ['bundler ~>1.3'],

  $rbenv_plugins = {
    'ruby-build' => {
      'ensure' => 'v20130514',
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
