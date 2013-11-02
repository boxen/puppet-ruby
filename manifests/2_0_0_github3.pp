# Installs ruby 2.0.0-github3 via ruby-build.
#
# Usage:
#
#     include ruby::2_0_0_github3

class ruby::2_0_0_github3 {
  require autoconf
  require openssl

  ruby::definition { '2.0.0-github3': }
  ruby::version    { '2.0.0-github3': }

  if $::operatingsystem == 'Darwin' {
    include homebrew::config

    Ruby::Version['2.0.0-github3'] {
      env => {
        'RUBY_CONFIGURE_OPTS' => "--with-openssl-dir=${homebrew::config::installdir}/opt/openssl",
      }
    }
  }

}
