define ruby::gem($gem, $ruby, $version = ">= 0") {
  require rbenv

  rbenv_gem { $name:
    gem           => $gem,
    version       => $version,
    rbenv_root    => $rbenv::root,
    rbenv_version => $ruby,
  }
}
