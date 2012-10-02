define ruby::local($version, $ensure = present) {
  if $version != 'system' {
    require join(['ruby', join(split($version, '[.]'), '-')], '::')
  }

  file { "${name}/.rbenv-version":
    ensure  => $ensure,
    content => "${version}\n",
    replace => true
  }
}
