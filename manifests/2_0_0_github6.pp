# Installs ruby 2.0.0-github6 from rbenv.
#
# Usage:
#
#     include ruby::2_0_0_github6

class ruby::2_0_0_github6 {
  require autoconf

  ruby::definition { '2.0.0-github6': }
  ruby::version    { '2.0.0-github6': }
}
