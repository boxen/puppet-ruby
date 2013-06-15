# Installs ruby 1.9.3-p231-tcs-github-1.0.30 from rbenv.
#
# Usage:
#
#     include ruby::1.9.3-p231-tcs-github-1.0.30

class ruby::1_9_3_p231_tcs_github_1_0_30 {
  require autoconf
  require xquartz

  ruby::definition { '1.9.3-p231-tcs-github-1.0.30': }
  ruby::version    { '1.9.3-p231-tcs-github-1.0.30': }

  if $::operatingsystem == 'Darwin' and $::macosx_productversion_major == '10.9' {
    Ruby::Version['1.9.3-p231-tcs-github-1.0.30'] {
      env => { 'CFLAGS' => '-I/opt/X11/include' }
    }
  }
}
