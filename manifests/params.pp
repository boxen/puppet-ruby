# Public: Configuration values for ruby
class ruby::params {
  case $::osfamily {
    'Darwin': {
      include boxen::config

      $chruby_root    = "${boxen::config::home}/chruby"
      $rubybuild_root = "${boxen::config::home}/ruby-build"
      $user           = $::boxen_user
    }

    default: {
      $chruby_root    = '/usr/local/share/chruby'
      $rubybuild_root = '/usr/local/share/ruby-build'
      $user           = 'root'
    }
  }

  $chruby_version    = 'v0.3.6'
  $rubybuild_version = 'v20131008'

  $default_gems = ['bundler ~>1.3']
}
