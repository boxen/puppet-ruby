# Installs ruby 2.0.0-github3 via ruby-build.
#
# Usage:
#
#     include ruby::2_0_0_github3

class ruby::2_0_0_github3 {
  require autoconf
  require xquartz

  ruby::definition { '2.0.0-github3': }
  ruby::version    { '2.0.0-github3': }

  if $::macosx_productversion_major == '10.9' {
    include homebrew::config
    require openssl

    Ruby::Version['2.0.0-github3'] {
      env => {
        'RUBY_CONFIGURE_OPTS' => "--with-openssl-dir=${homebrew::config::installdir}/opt/openssl",
      }
    }
  }

}
