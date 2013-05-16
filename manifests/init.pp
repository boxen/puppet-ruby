# Class: ruby
#
# This module installs a full rbenv-driven ruby stack
#
class ruby(
  $rbenv_version              = 'v0.4.0',
  $ruby_build_version         = 'v20130514',

  $default_gems               = ['bundler ~>1.3'],

  $rbenv_gem_rehash_version   = 'v1.0.0',
  $rbenv_default_gems_version = 'v1.0.0',
) {
  include boxen::config

  $root = "${boxen::config::home}/rbenv"

  file {
    $root:
      ensure => directory;
    [
      "${root}/plugins",
      "${root}/rbenv.d",
      "${root}/rbenv.d/install",
      "${root}/shims",
      "${root}/versions",
    ]:
      ensure  => directory,
      require => Exec['rbenv-setup-root-repo'];
    "${root}/rbenv.d/install/00_try_to_download_ruby_version.bash":
      ensure => present,
      mode   => '0755',
      source => 'puppet:///modules/ruby/try_to_download_ruby_version.bash';
    "${boxen::config::envdir}/rbenv.sh":
      source => 'puppet:///modules/ruby/rbenv.sh' ;
  }

  $git_init   = 'git init .'
  $git_remote = 'git remote add origin https://github.com/sstephenson/rbenv.git'
  $git_fetch  = 'git fetch -q origin'
  $git_reset  = "git reset --hard ${rbenv_version}"

  exec { 'rbenv-setup-root-repo':
    command => "${git_init} && ${git_remote} && ${git_fetch} && ${git_reset}",
    cwd     => $root,
    creates => "${root}/bin/rbenv",
    require => [ File[$root], Class['git'] ]
  }

  exec { "ensure-rbenv-version-${rbenv_version}":
    command => "${git_fetch} && git reset --hard ${rbenv_version}",
    unless  => "git describe --tags --exact-match `git rev-parse HEAD` | grep ${rbenv_version}",
    cwd     => $root,
    require => Exec['rbenv-setup-root-repo']
  }

  ruby::plugin {
    'rbenv-default-gems':
      version => $rbenv_default_gems_version,
      source  => 'sstephenson/rbenv-default-gems' ;

    'rbenv-gem-rehash':
      version => $rbenv_gem_rehash_version,
      source  => 'sstephenson/rbenv-gem-rehash' ;

    'ruby-build':
      version => $ruby_build_version,
      source  => 'sstephenson/ruby-build' ;
  }
  
  file { "${root}/default-gems":
    content => template('ruby/default-gems.erb'),
    tag     => 'ruby_plugin_config'
  }

  Ruby::Definition <| |> ->
    Ruby::Plugin <| |> ->
    File <| tag == 'ruby_plugin_config' |> ->
    Ruby::Version <| |>
}
