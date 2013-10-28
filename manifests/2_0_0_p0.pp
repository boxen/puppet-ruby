# Installs ruby 2.0.0-p0.

class ruby::2_0_0_p0 {
  require openssl

  ruby::version { '2.0.0-p0': }

  if $::operatingsystem == 'Darwin' {
    require xquartz

    include homebrew::config

    Ruby::Version['2.0.0-p0'] {
      env => {
        'RUBY_CONFIGURE_OPTS' => "--with-openssl-dir=${homebrew::config::installdir}/opt/openssl",
      }
    }
  }

}
