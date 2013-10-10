require "spec_helper"

describe "ruby::source" do
  let(:title) { 'example' }
  let(:params) do
    {
      :source => 'http://example.com'
    }
  end
  context "ensure => present(default)" do
    it do
        should contain_exec('gem sources --add http://example.com').with({
          :unless => 'gem sources --list | grep http://example.com'
        })
    end
  end
  context "ensure => absent" do
    let(:params) do
      {
        :ensure => 'absent',
        :source => 'http://example.com'
      }
    end
    it do
        should contain_exec('gem sources --remove http://example.com').with({
          :onlyif => 'gem sources --list | grep http://example.com'
        })
    end
  end
end

