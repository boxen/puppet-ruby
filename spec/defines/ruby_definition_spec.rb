require 'spec_helper'

describe 'ruby::definition' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen'
    }
  end

  let(:title) { '1.9.3-p231-github1' }

  let(:definition_path) do
    [
      '/opt',
      'boxen',
      'rbenv',
      'plugins',
      'ruby-build',
      'share',
      'ruby-build',
      title
    ].join('/')
  end

  context "with source" do
    let(:whatever_source) { 'puppet:///modules/ruby/whatever_def' }
    let(:params) do
      {
        :source => whatever_source
      }
    end

    it do
      should contain_file(definition_path).with_source(whatever_source)
    end
  end

  it do
    should include_class('homebrew')
    should include_class('ruby')

    should contain_file(definition_path).with({
      :source  => "puppet:///modules/ruby/definitions/#{title}",
      :require => 'Exec[ensure-ruby-build-version-v20130227]'
    })
  end
end
