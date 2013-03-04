# Class: ruby
#
# This module installs a full rbenv-driven ruby stack
#
class ruby {
  include boxen::config
  include homebrew

  $root = "${boxen::config::home}/rbenv"
  $rbenv_version = 'v0.4.0'
  $ruby_build_version = 'v20130227'

  package { ['rbenv', 'ruby-build']: ensure => absent; }

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

  repository { "${root}/plugins/ruby-build":
    source  => 'sstephenson/ruby-build',
    extra   => "-b ${ruby_build_version}",
    require => File["${root}/plugins"]
  }

  exec { "ensure-rbenv-version-${rbenv_version}":
    command => "${git_fetch} && git reset --hard ${rbenv_version}",
    unless  => "git describe --tags --exact-match `git rev-parse HEAD` | grep ${rbenv_version}",
    cwd     => $root,
    require => Exec['rbenv-setup-root-repo']
  }

  exec { 'rbenv-rehash-post-install':
    command => "/bin/rm -rf ${root}/shims && RBENV_ROOT=${root} ${root}/bin/rbenv rehash",
    unless  => "grep /opt/boxen/rbenv/libexec ${root}/shims/gem",
    require => Exec["ensure-rbenv-version-${rbenv_version}"],
  }

  exec { "ensure-ruby-build-version-${ruby_build_version}":
    command => "${git_fetch} && git reset --hard ${ruby_build_version}",
    unless  => "git describe --tags --exact-match `git rev-parse HEAD` | grep ${ruby_build_version}",
    cwd     => "${root}/plugins/ruby-build",
    require => Repository["${root}/plugins/ruby-build"],
  }

  Ruby::Definition <| |> -> Ruby::Version <| |>
}
