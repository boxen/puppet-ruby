class ruby::1-9-3 {
  require rbenv
  require ruby::1-9-3-p194

  file { "${rbenv::root}/versions/1.9.3":
    ensure  => symlink,
    force   => true,
    target  => "${rbenv::root}/versions/1.9.3-p194"
  }
}
