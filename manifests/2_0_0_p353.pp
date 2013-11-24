# Installs ruby 2.0.0-p353.

class ruby::2_0_0_p353 {
  require openssl

  ruby::version { '2.0.0-p353': }
}

