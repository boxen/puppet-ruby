# Set a directory's default ruby version via rbenv.
# Automatically ensures that ruby version is installed via rbenv.
#
# Usage:
#
#     ruby::local { '/path/to/a/thing': version => '2.2.0' }

define ruby::local($version = undef, $ensure = present) {
  include ruby

  case $version {
    'system': { $_ruby_local_require = undef }
    undef:    { $_ruby_local_require = undef }
    default:  {
      ensure_resource('ruby::version', $version)
      $_ruby_local_require = Ruby::Version[$version]
    }
  }

  file {
    "${name}/.ruby-version":
      ensure  => $ensure,
      content => "${version}\n",
      replace => true,
      require => $_ruby_local_require ;

    "${name}/.rbenv-version":
      ensure  => absent,
      before  => File["${name}/.ruby-version"],
      require => $_ruby_local_require ;
  }
}
