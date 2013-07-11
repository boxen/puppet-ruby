# Installs ruby 2.0.0-p195.

class ruby::2_0_0_p195 {
  require openssl

  ruby::version { '2.0.0-p195': }
}
