# frozen_string_literal: true

RSpec.describe K8s::Templates::Compiler::Options do
  it 'has method parse' do
    expect(K8s::Templates::Compiler::Options.method_defined?(:parse)).to eq(true)
  end

  context 'cli options' do
    it 'has environment' do
      parser = K8s::Templates::Compiler::Options.new
      options = parser.parse(['--environment', 'dev'])

      expect(options[:environment]).to eq('dev')

      parser = K8s::Templates::Compiler::Options.new
      options = parser.parse(['-e', 'dev'])

      expect(options[:environment]).to eq('dev')
    end

    it 'has no environment' do
      parser = K8s::Templates::Compiler::Options.new

      expect { parser.parse([]) }.to raise_error(OptionParser::MissingArgument)
    end

    it 'return array' do
      compiler = K8s::Templates::Compiler::Options.new
      expect(compiler.parse(['--environment', 'dev']).is_a?(Hash)).to eq(true)
    end

    it 'has debug mode' do
      parser = K8s::Templates::Compiler::Options.new
      options = parser.parse(['--environment', 'dev', '--debug'])

      expect(options[:debug]).to eq(true)

      parser = K8s::Templates::Compiler::Options.new
      options = parser.parse(['--environment', 'dev', '-d'])

      expect(options[:debug]).to eq(true)
    end

    it 'has default templates dir' do
      parser = K8s::Templates::Compiler::Options.new
      options = parser.parse(['--environment', 'dev'])

      expect(options[:template_dir]).to eq('template')
    end

    it 'has custome templates dir' do
      parser = K8s::Templates::Compiler::Options.new
      options = parser.parse(['--environment', 'dev', '-t', 'zupa'])

      expect(options[:template_dir]).to eq('zupa')
    end

    it 'has default config dir' do
      parser = K8s::Templates::Compiler::Options.new
      options = parser.parse(['--environment', 'dev'])

      expect(options[:config_dir]).to eq('config')
    end

    it 'has custome config dir' do
      parser = K8s::Templates::Compiler::Options.new
      options = parser.parse(['--environment', 'dev', '-c', 'zupa'])

      expect(options[:config_dir]).to eq('zupa')
    end
  end

  context 'project variables' do
    it 'has empty options values for empty file' do
      parser = K8s::Templates::Compiler::Options.new
      options = parser.parse(['--environment', 'empty', '-c', 'spec/files/options'])

      puts options[:values].inspect

      expect(options[:values].is_a?(Hash)).to eq(true)
      expect(options[:values].empty?).to eq(true)
    end

    it 'has empty options values for namespace' do
      parser = K8s::Templates::Compiler::Options.new
      options = parser.parse(['--environment', 'withnamespace', '-c', 'spec/files/options'])

      puts options[:values]

      # expect(options[:values][:namespace][:name]).to eq('test')
    end
  end

end
