# Installs ruby 1.9.3-p231-tcs-github-1.0.32 from rbenv.
#
# Usage:
#
#     include ruby::1.9.3-p231-tcs-github-1.0.32

class ruby::1_9_3_p231_tcs_github_1_0_32 {
  require autoconf
  require xquartz

  ruby::definition { '1.9.3-p231-tcs-github-1.0.32': }
  ruby::version    { '1.9.3-p231-tcs-github-1.0.32': }

  if $::operatingsystem == 'Darwin' and $::macosx_productversion_major == '10.9' {
    Ruby::Version['1.9.3-p231-tcs-github-1.0.32'] {
      env => { 'CFLAGS' => '-I/opt/X11/include' }
    }
  }
}
