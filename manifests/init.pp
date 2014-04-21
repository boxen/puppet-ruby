# Class: ruby
#
# This module installs a full rbenv-driven ruby stack
#
class ruby(
  $provider = $ruby::provider,
  $prefix   = $ruby::prefix,
  $user     = $ruby::user,
) {
  if $::osfamily == 'Darwin' {
    include boxen::config

    boxen::env_script { 'ruby':
      content  => template('ruby/ruby.sh'),
      priority => 'higher',
    }
  }

  include ruby::build

  $provider_class = "ruby::${provider}"
  include $provider_class

  file { '/opt/rubies':
    ensure => directory,
    owner  => $user,
  }

  Class['ruby::build'] ->
    Ruby::Definition <| |> ->
    Class[$provider_class] ->
    Ruby <| |> ->
    Ruby_gem <| |>
}
