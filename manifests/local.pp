# Set a directory's default ruby version via rbenv.
# Automatically ensures that ruby version is installed via rbenv.
#
# Usage:
#
#     ruby::local { '/path/to/a/thing': version => '1.9.3-p194' }

define ruby::local($version = undef, $ensure = present) {
  include ruby

  if $version != 'system' {
    ensure_resource('ruby::version', $version)
    $require = Ruby::Version[$version]
  } else {
    $require = undef
  }

  file {
    "${name}/.ruby-version":
      ensure  => $ensure,
      content => "${version}\n",
      replace => true,
      require => $require ;

    "${name}/.rbenv-version":
      ensure  => absent,
      before  => "${name}/.ruby-version",
      require => $require ;
  }
}
