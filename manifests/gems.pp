# Class: ruby::gems
#
# (INTERNAL) Installs global ruby gems
class ruby::gems {
  ruby_gem { 'bundler for all rubies':
    gem          => 'bundler',
    version      => '~> 1.0',
    ruby_version => '*',
  }
}
