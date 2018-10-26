# frozen_string_literal: true

require 'fileutils'

RSpec.describe K8s::Templates::Compiler::Cli do
  it 'has method run' do
    expect(K8s::Templates::Compiler::Cli.method_defined?(:run)).to eq(true)
  end

  it 'return integer' do
    compiler = K8s::Templates::Compiler::Cli.new
    expect(compiler.run(['--environment', 'dev']).is_a?(Integer)).to eq(true)
  end

  it 'has no environment' do
    compiler = K8s::Templates::Compiler::Cli.new
    expect(compiler.run).to eq(1)
  end

  context 'environments' do
    before(:context) do
      @tmp_dir = '.tmp'
      @config_dir = @tmp_dir + '/config'

      @environments = %w[test1 test2]

      FileUtils.rm_rf(@tmp_dir)
      FileUtils.mkdir_p(@config_dir)
      @environments.each do |environment|
        FileUtils.mkdir_p(@config_dir + '/' + environment)
      end
    end

    it 'has defined environment' do
      compiler = K8s::Templates::Compiler::Cli.new

      expect(compiler).to receive(:run_compilation).once

      expect(compiler.run(['--environment', 'dev', '-c', '.tmp/config'])).to eq(0)
    end

    it 'has all-environment option' do
      compiler = K8s::Templates::Compiler::Cli.new

      expect(compiler).to receive(:run_compilation).twice

      expect(compiler.run(['--all-environments', '-c', '.tmp/config'])).to eq(0)
    end

    after(:context) do
      FileUtils.rm_rf(@tmp_dir)
    end
  end
end
