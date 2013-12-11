# Installs ruby 2.0.0-preview2.

class ruby::2_0_0_preview2 {
  require openssl

  ruby::version { '2.0.0-preview2': }
}
