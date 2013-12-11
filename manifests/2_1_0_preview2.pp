# Installs ruby 2.1.0-preview2.

class ruby::2_1_0_preview2 {
  require openssl

  ruby::version { '2.1.0-preview2': }
}
