# Class: ruby
#
# This module installs a full rbenv-driven ruby stack
#
class ruby(
  $default_gems  = $ruby::params::default_gems,
  $rbenv_plugins = {},
  $rbenv_version = $ruby::params::rbenv_version,
  $rbenv_root    = $ruby::params::rbenv_root,
  $user          = $ruby::params::user
) inherits ruby::params {

  if $::osfamily == 'Darwin' {
    include boxen::config

    file { "${boxen::config::envdir}/rbenv.sh":
      source => 'puppet:///modules/ruby/rbenv.sh' ;
    }
  }

  repository { $rbenv_root:
    ensure => $rbenv_version,
    source => 'sstephenson/rbenv',
    user   => $user
  }

  file {
    [
      "${rbenv_root}/plugins",
      "${rbenv_root}/rbenv.d",
      "${rbenv_root}/rbenv.d/install",
      "${rbenv_root}/shims",
      "${rbenv_root}/versions",
    ]:
      ensure  => directory,
      require => Repository[$rbenv_root];

    "${rbenv_root}/rbenv.d/install/00_try_to_download_ruby_version.bash":
      mode   => '0755',
      source => 'puppet:///modules/ruby/try_to_download_ruby_version.bash';
  }

  $_real_rbenv_plugins = merge($ruby::params::rbenv_plugins, $rbenv_plugins)
  create_resources('ruby::plugin', $_real_rbenv_plugins)


  if has_key($_real_rbenv_plugins, 'rbenv-default-gems') {
    $gem_list = join($default_gems, "\n")

    file { "${rbenv_root}/default-gems":
      content => "${gem_list}\n",
      tag     => 'ruby_plugin_config'
    }
  }

  Repository[$rbenv_root] ->
    File <| tag == 'ruby_plugin_config' |> ->
    Ruby::Plugin <| |> ->
    Ruby::Definition <| |> ->
    Ruby::Version <| |>
}
