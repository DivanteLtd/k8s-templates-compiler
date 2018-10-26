# frozen_string_literal: true

RSpec.describe K8s::Templates::Compiler::Options do
  it 'has method parse' do
    expect(K8s::Templates::Compiler::Options.method_defined?(:parse)).to eq(true)
  end

  context 'cli environment options' do
    it 'has environment' do
      parser = K8s::Templates::Compiler::Options.new
      options = parser.parse(['--environment', 'dev'])

      expect(options[:environment]).to eq('dev')

      parser = K8s::Templates::Compiler::Options.new
      options = parser.parse(['-e', 'dev'])

      expect(options[:environment]).to eq('dev')
    end

    it 'has all-environments' do
      parser = K8s::Templates::Compiler::Options.new
      options = parser.parse(['--all-environments'])

      expect(options[:all_environments]).to eq(true)
    end

    it 'has no environment and no all-environments' do
      parser = K8s::Templates::Compiler::Options.new

      expect { parser.parse([]) }.to raise_error(OptionParser::MissingArgument)
    end

    it 'has environment and all-environments' do
      parser = K8s::Templates::Compiler::Options.new

      expect do
        parser.parse(['--environment', 'dev', '--all-environments'])
      end.to raise_error(OptionParser::InvalidOption)
    end

    it 'return array' do
      compiler = K8s::Templates::Compiler::Options.new
      expect(compiler.parse(['--environment', 'dev']).is_a?(Hash)).to eq(true)
    end
  end

  context 'cli output dir options' do
    it 'has default output dir' do
      parser = K8s::Templates::Compiler::Options.new
      options = parser.parse(['--environment', 'dev'])

      expect(options[:output_dir]).to eq('env')
    end

    it 'has custome output dir' do
      parser = K8s::Templates::Compiler::Options.new
      options = parser.parse(['--environment', 'dev', '-o', 'zupa'])

      expect(options[:output_dir]).to eq('zupa')
    end

    it 'has custome output dir' do
      parser = K8s::Templates::Compiler::Options.new
      options = parser.parse(['-o', 'zupa', '--environment', 'dev'])

      expect(options[:output_dir]).to eq('zupa')
    end
  end

  context 'cli another options' do
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

    it 'has create env if not exists option' do
      parser = K8s::Templates::Compiler::Options.new
      options = parser.parse(['--environment', 'dev', '--create'])

      expect(options[:create]).to eq(true)

      parser = K8s::Templates::Compiler::Options.new
      options = parser.parse(['--create', '--environment', 'dev'])

      expect(options[:create]).to eq(true)
    end
  end

  context 'project variables' do
    it 'should return error if values are not valid json' do
      parser = K8s::Templates::Compiler::Options.new

      expect do
        parser.parse(
          [
            '--environment', 'withnamespace',
            '-c', 'spec/unit/files/options',
            '--values', 'some text'
          ]
        )
      end.to raise_error(OptionParser::InvalidOption)
    end

    it 'can parse values from command line option' do
      parser = K8s::Templates::Compiler::Options.new

      options = parser.parse(
        [
          '--environment', 'withnamespace',
          '-c', 'spec/unit/files/options',
          '--values', '{"namespace": {"name": "overwrited"}}'
        ]
      )

      expect(options[:values]).to eq('{"namespace": {"name": "overwrited"}}')
    end
  end
end
