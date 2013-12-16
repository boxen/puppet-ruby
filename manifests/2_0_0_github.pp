# Installs ruby 2.0.0-github blessed version from rbenv.
#
# Usage:
#
#     include ruby::2_0_0_github

class ruby::2_0_0_github {
  ruby::version { '2.0.0-github': }
}
