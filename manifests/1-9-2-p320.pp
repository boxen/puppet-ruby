class ruby::1-9-2-p320 {
  ruby { '1.9.2-p320':
    cc      => '/usr/local/bin/gcc-4.2',
    require => Package['boxen/brews/apple-gcc42']
  }
}
