# Installs ruby 2.0.0-p195.

class ruby::2_0_0_p195 {
  require openssl

  ruby::version { '2.0.0-p195': }

  if $::operatingsystem == 'Darwin' {
    include homebrew::config

    Ruby::Version['2.0.0-p195'] {
      env => {
        'RUBY_CONFIGURE_OPTS' => "--with-openssl-dir=${homebrew::config::installdir}/opt/openssl",
      }
    }
  }

}
