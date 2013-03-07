# Public: Installs our blessed version of jruby and symlinks it in rbenv
# to "jruby"
#
# Usage:
#
#   include ruby::jruby

class ruby::jruby {
  require ruby
  require ruby::jruby_1_7_3

  ruby::alias { 'jruby': target => 'jruby-1.7.3' }
}
