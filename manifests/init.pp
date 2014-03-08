# Class: ruby
#
# This module installs a full rbenv-driven ruby stack
#
class ruby(
  $provider = $ruby::provider,
  $prefix   = $ruby::prefix,
  $user     = $ruby::user,
) {

  include 'ruby::build'
  include "ruby::${provider}"

  if $::osfamily == 'Darwin' {
    include boxen::config

    boxen::env_script { 'ruby':
      content  => template('ruby/ruby.sh'),
      priority => 'higher',
    }
  }

  file { '/opt/rubies':
    ensure => directory,
    owner  => $user,
  }

  Class['ruby::build'] ->
    Ruby::Definition <| |> ->
    Class["ruby::${provider}"] ->
    Ruby::Version <| |> ->
    Ruby::Gem <| |>
}
