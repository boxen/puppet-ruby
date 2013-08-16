# Public: ruby::definition allows you to install a ruby-build definition.
#
#   source =>
#     The puppet:// source to install from. If undef, looks in
#     puppet:///modules/ruby/definitions/${name}.

define ruby::definition($source = undef) {
  include ruby

  $source_path = $source ? {
    undef   => "puppet:///modules/ruby/definitions/${name}",
    default => $source
  }

  file { "${ruby::rubybuild_root}/share/ruby-build/${name}":
    source  => $source_path
  }
}
