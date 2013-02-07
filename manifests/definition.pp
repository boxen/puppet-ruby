# Public: ruby::definition allows you to install a ruby-build definition.
#
#   source =>
#     The puppet:// source to install from. If undef, looks in
#     puppet:///modules/ruby/definitions/${name}.

define ruby::definition($source = undef) {
  include homebrew
  include ruby

  $source_path = $source ? {
    undef   => "puppet:///modules/ruby/definitions/${name}",
    default => $source
  }

  $cellar = "${homebrew::config::installdir}/Cellar/"
  $install_path = "${cellar}/ruby-build/${ruby::ruby_build_version}"

  file { "${install_path}/share/ruby-build/${name}":
    source  => $source_path,
    require => Package['ruby-build']
  }
}