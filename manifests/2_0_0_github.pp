# Installs ruby 2.0.0-github blessed version from rbenv.
#
# Usage:
#
#     include ruby::2_0_0_github

class ruby::2_0_0_github {
  require ruby
  require ruby::2_0_0_github3

  file { "${ruby::rbenv_root}/versions/2.0.0-github":
    ensure  => symlink,
    force   => true,
    target  => "${ruby::rbenv_root}/versions/2.0.0-github3",
  }
}
