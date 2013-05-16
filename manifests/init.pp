# Class: ruby
#
# This module installs a full rbenv-driven ruby stack
#
class ruby(
  $default_gems  = $ruby::params::default_gems,
  $rbenv_plugins = $ruby::params::rbenv_plugins,
  $rbenv_version = $ruby::params::rbenv_version,
  $root          = $ruby::params::rbenv_root,
) inherits ruby::params {
  case $::osfamily {
    'Darwin': {
      include boxen::config

      file { "${boxen::config::envdir}/rbenv.sh":
        source => 'puppet:///modules/ruby/rbenv.sh' ;
      }
    }

    default: {
      # noop
    }
  }

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

  create_resources('ruby::plugin', $rbenv_plugins)

  file { "${root}/default-gems":
    content => template('ruby/default-gems.erb'),
    tag     => 'ruby_plugin_config'
  }

  Ruby::Definition <| |> ->
    Ruby::Plugin <| |> ->
    File <| tag == 'ruby_plugin_config' |> ->
    Ruby::Version <| |>
}
