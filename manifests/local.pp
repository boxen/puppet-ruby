# Set a directory's default ruby version via rbenv.
# Automatically ensures that ruby version is installed via rbenv.
#
# Usage:
#
#     ruby::local { '/path/to/a/thing': version => '1.9.3-p194' }

define ruby::local($version = undef, $ensure = present) {
  if $version != 'system' and $ensure == present {
    $klass = join(['ruby', join(split($version, '[.-]'), '_')], '::')
    require $klass
  }

  file {
    "${name}/.ruby-version":
      ensure  => $ensure,
      content => "${version}\n",
      replace => true ;
    "${name}/.rbenv-version":
      ensure  => absent ;
  }
}
