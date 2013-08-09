# Installs ruby 2.0.0-github3 from rbenv.
#
# Usage:
#
#     include ruby::2_0_0_github3

class ruby::2_0_0_github3 {
  require autoconf
  require xquartz

  ruby::definition { '2.0.0-github3': }
  ruby::version    { '2.0.0-github3': }
}
