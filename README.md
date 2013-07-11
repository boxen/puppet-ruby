# Ruby Puppet Module for Boxen

[![Build Status](https://travis-ci.org/boxen/puppet-ruby.png)](https://travis-ci.org/boxen/puppet-ruby)

Requires the following boxen modules:

* `boxen`
* `repository >= 2.1`
* `xquartz` (OS X only)
* `autoconf` (some ruby versions)
* `openssl` (ruby versions >= 2.0.0)

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
  ensure => 'v1.2.0',
  source  => 'sstephenson/rbenv-vars'
}
```

## Hiera configuration

The following variables may be automatically overridden with Hiera:

``` yaml
---
"ruby::default_gems":
  - "bundler ~>1.3"
  - "pry"
"ruby::rbenv_plugins":
  "rbenv-gem-rehash":
    "ensure": "v1.0.0"
    "source": "sstephenson/rbenv-gem-rehash"

"ruby::rbenv_version": "v0.4.0"

"ruby::rbenv_root": "/home/deploy/rbenv"

"ruby::user": "deploy"
```

You can also use JSON if your Hiera is configured for that.
