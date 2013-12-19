# Installs jruby 1.7.6 from rbenv.
#
# Usage:
#
#     include ruby::jruby_1_7_6
class ruby::jruby_1_7_6 {
  require java

  ruby::version { 'jruby-1.7.6': }
}
