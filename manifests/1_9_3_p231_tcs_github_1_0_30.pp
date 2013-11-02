# Installs ruby 1.9.3-p231-tcs-github-1.0.30 via ruby-build.
#
# Usage:
#
#     include ruby::1.9.3-p231-tcs-github-1.0.30

class ruby::1_9_3_p231_tcs_github_1_0_30 {
  require autoconf

  ruby::definition { '1.9.3-p231-tcs-github-1.0.30': }
  ruby::version    { '1.9.3-p231-tcs-github-1.0.30': }
}
