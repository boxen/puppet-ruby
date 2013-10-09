# Add/Remove ruby sources
#
# Usage:
#   ruby::source { 'my_local_mirror':
#     source => 'https://mymirror.com'
#   }

define ruby::source($source, $ensure = 'present') {
  if $ensure == 'present' {
    exec { "gem sources --add ${source}":
      unless => "gem sources --list | grep ${source}"
    }
  }
  if $ensure == 'absent' {
    exec { "gem sources --remove ${source}":
      onlyif => "gem sources --list | grep ${source}"
    }
  }
}
