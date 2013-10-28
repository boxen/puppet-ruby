# Installs ruby 2.0.0-github6 from rbenv.
#
# Usage:
#
#     include ruby::2_0_0_github6

class ruby::2_0_0_github6 {
  require autoconf
  require xquartz

  ruby::definition { '2.0.0-github6': }
  ruby::version    { '2.0.0-github6': }

  if $::macosx_productversion_major == '10.9' {
    include homebrew::config
    require openssl

    Ruby::Version['2.0.0-github6'] {
      env => {
        'RUBY_CONFIGURE_OPTS' => "--with-openssl-dir=${homebrew::config::installdir}/opt/openssl",
      }
    }
  }
}
