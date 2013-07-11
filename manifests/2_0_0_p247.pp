# Installs ruby 2.0.0-p247.

class ruby::2_0_0_p247 {
  require openssl

  ruby::version { '2.0.0-p247': }
}
