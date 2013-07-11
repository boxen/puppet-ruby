# Installs ruby 2.0.0-p0.

class ruby::2_0_0_p0 {
  require openssl

  ruby::version { '2.0.0-p0': }
}
