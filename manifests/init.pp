class ruby {
  require boxen::config
  require homebrew

  $root = "${boxen::config::home}/rbenv"

  file {
    [$root, "${root}/versions", "${root}/rbenv.d", "${root}/rbenv.d/install"]:
      ensure => directory;
    "${root}/rbenv.d/install/00_try_to_download_ruby_version.bash":
      ensure => present,
      mode   => '0755',
      source => 'puppet:///modules/ruby/try_to_download_ruby_version.bash';
  }

  package {
    'rbenv':      ensure => '0.4.0' ;
    'ruby-build': ensure => '20130104' ;
  }

  file { "${boxen::config::envdir}/rbenv.sh":
    source  => 'puppet:///modules/ruby/rbenv.sh'
  }
}