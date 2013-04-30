# Ruby Puppet Module for Boxen

Requires the following boxen modules:

* `boxen`

## Usage

```puppet
# Set the global default ruby (auto-installs it if it can)
class { 'ruby::global':
  version => '1.9.3'
}

# ensure a certain ruby version is used in a dir
ruby::local { '/path/to/some/project':
  version => '1.9.3-p194'
}

# ensure a gem is installed for a certain ruby version
# note, you can't have duplicate resource names so you have to name like so
ruby::gem { "bundler for ${version}":
  gem     => 'bundler',
  ruby    => $version,
  version => '~> 1.2.0'
}

# install a ruby version
ruby::version { '1.9.3-p194': }

# we provide a ton of predefined ones for you though
require ruby::1_9_3_p194

# Installing rbenv plugin
ruby::plugin { 'rbenv-vars':
  version => 'v1.2.0',
  source  => 'sstephenson/rbenv-vars'
}

# Run an installed gem
# rbenv-installed gems cannot be run in the boxen installation environment which uses the system
# ruby. The environment must be cleared (env -i) so an installed ruby (and gems) can be used in a new shell.
exec { "env -i zsh -c 'source /opt/boxen/env.sh && RBENV_VERSION=${version} bundle install'":
  provider => 'shell',
  cwd => "~/src/project",
  require => [ Ruby::Gem["bundler for ${version}"], Package['zsh'] ]
}
```
