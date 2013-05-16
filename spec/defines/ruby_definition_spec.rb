require 'spec_helper'

describe 'ruby::definition' do
  let(:facts) { default_test_facts }
  let(:title) { '1.9.3-p231-github1' }

  let(:definition_path) do
    [
      '/test',
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
    should include_class('ruby')

    should contain_file(definition_path).with({
      :source  => "puppet:///modules/ruby/definitions/#{title}"
    })
  end
end
