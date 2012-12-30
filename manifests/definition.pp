# A single ruby version definition

define ruby::definition() {
  file { "${homebrew::dir}/share/ruby-build/${name}":
    source    => "puppet:///modules/ruby/definitions/${name}",
    owner     => $::luser,
    subscribe => Package['ruby-build']
  }
}