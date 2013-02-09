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

  file { "${ruby::root}/plugins/ruby-build/share/ruby-build/${name}":
    source  => $source_path,
    require => Exec["ensure-ruby-build-version-${ruby::ruby_build_version}"]
  }
}