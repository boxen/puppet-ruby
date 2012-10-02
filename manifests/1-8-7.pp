class ruby::1-8-7 {
  require rbenv
  require ruby::1-8-7-p358

  file { "${rbenv::root}/versions/1.8.7":
    ensure  => symlink,
    force   => true,
    target  => "${rbenv::root}/versions/1.8.7-p358"
  }
}
