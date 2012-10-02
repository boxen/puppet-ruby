class ruby::1-9-2 {
  require rbenv
  require ruby::1-9-2-p320

  file { "${rbenv::root}/versions/1.9.2":
    ensure  => symlink,
    force   => true,
    target  => "${rbenv::root}/versions/1.9.2-p320"
  }
}
