# Class: ruby
#
# This module installs a full rbenv-driven ruby stack
#
class ruby {
  require boxen::config
  require homebrew

  $root = "${boxen::config::home}/rbenv"
  $rbenv_version = '0.4.0'
  $ruby_build_version = '20130118'

  file {
    [$root, "${root}/versions", "${root}/rbenv.d", "${root}/rbenv.d/install"]:
      ensure => directory;
    "${root}/rbenv.d/install/00_try_to_download_ruby_version.bash":
      ensure => present,
      mode   => '0755',
      source => 'puppet:///modules/ruby/try_to_download_ruby_version.bash';
  }

  package {
    'rbenv':      ensure => $rbenv_version ;
    'ruby-build': ensure => $ruby_build_version ;
  }

  file { "${boxen::config::envdir}/rbenv.sh":
    source  => 'puppet:///modules/ruby/rbenv.sh'
  }

  Ruby::Definition <| |> -> Ruby::Version <| |>
}
