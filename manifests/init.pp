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
  if $::osfamily == 'Darwin' {
    include boxen::config

    file { "${boxen::config::envdir}/rbenv.sh":
      source => 'puppet:///modules/ruby/rbenv.sh' ;
    }
  }

  repository { $root:
    ensure => $rbenv_version,
    source => 'sstephenson/rbenv'
  }

  file {
    [
      "${root}/plugins",
      "${root}/rbenv.d",
      "${root}/rbenv.d/install",
      "${root}/shims",
      "${root}/versions",
    ]:
      ensure  => directory,
      require => Repository[$root];

    "${root}/rbenv.d/install/00_try_to_download_ruby_version.bash":
      mode   => '0755',
      source => 'puppet:///modules/ruby/try_to_download_ruby_version.bash';
  }

  create_resources('ruby::plugin', $rbenv_plugins)

  file { "${root}/default-gems":
    content => template('ruby/default-gems.erb'),
    tag     => 'ruby_plugin_config'
  }

  Repository[$root] ->
    File <| tag == 'ruby_plugin_config' |> ->
    Ruby::Plugin <| |> ->
    Ruby::Definition <| |> ->
    Ruby::Version <| |>
}
