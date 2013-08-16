# Class: ruby
#
# This module installs a full chruby-driven ruby stack
#
class ruby(
  $default_gems      = $ruby::params::default_gems,
  $chruby_version    = $ruby::params::chruby_version,
  $chruby_root       = $ruby::params::chruby_root,
  $rubybuild_version = $ruby::params::rubybuild_version
  $rubybuild_root    = $ruby::params::rubybuild_root
  $user              = $ruby::params::user
) inherits ruby::params {

  if $::osfamily == 'Darwin' {
    include boxen::config

    file { "${boxen::config::envdir}/chruby.sh":
      source => 'puppet:///modules/ruby/chruby.sh' ;
    }
  }

  repository { $chruby_root:
    ensure => $chruby_version,
    source => 'postmodern/chruby',
    user   => $user,
  }

  repository { $rubybuild_root:
    ensure => $rubybuild_version,
    source => 'sstephenson/ruby-build',
    user   => $user,
  }

  #file {
  #  [
  #    "${rbenv_root}/versions",
  #  ]:
  #    ensure  => directory,
  #    require => Repository[$rbenv_root];

  #  "${rbenv_root}/rbenv.d/install/00_try_to_download_ruby_version.bash":
  #    mode   => '0755',
  #    source => 'puppet:///modules/ruby/try_to_download_ruby_version.bash';
  #}

  #Repository[$chruby_root] ->
  #  Ruby::Definition <| |> ->
  #  Ruby::Version <| |>
}
