# Public: Installs JRuby 1.7.3 from rbenv
#
# Usage:
#
#   include ruby::jruby_1_7_3


class ruby::jruby_1_7_3 {
  include ruby
  include java

  ruby::version { 'jruby-1.7.3': }

  Ruby::Version <| title == 'jruby-1.7.3' |> {
    require +> Class['java']
  }
}
