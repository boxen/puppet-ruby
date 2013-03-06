class ruby::jruby {
  require ruby
  require ruby::jruby_1_7_3

  ruby::alias { 'jruby': target => 'jruby-1.7.3' }
}
