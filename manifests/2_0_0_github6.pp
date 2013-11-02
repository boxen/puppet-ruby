# Installs ruby 2.0.0-github6 from rbenv.
#
# Usage:
#
#     include ruby::2_0_0_github6

class ruby::2_0_0_github6 {
  require autoconf
  require openssl

  ruby::definition { '2.0.0-github6': }
  ruby::version    { '2.0.0-github6': }

  if $::operatingsystem == 'Darwin' {
    include homebrew::config

    Ruby::Version['2.0.0-github6'] {
      env => {
        'RUBY_CONFIGURE_OPTS' => "--with-openssl-dir=${homebrew::config::installdir}/opt/openssl",
      }
    }
  }
}
