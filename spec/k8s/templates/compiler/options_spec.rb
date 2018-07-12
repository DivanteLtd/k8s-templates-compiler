# frozen_string_literal: true

RSpec.describe K8s::Templates::Compiler::Options do
  it 'has method parse' do
    expect(K8s::Templates::Compiler::Options.method_defined?(:parse)).to eq(true)
  end

  it 'has environment' do
    parser = K8s::Templates::Compiler::Options.new
    options = parser.parse(['--environment', 'dev'])

    expect(options[:environment]).to eq('dev')

    parser = K8s::Templates::Compiler::Options.new
    options = parser.parse(["-e", 'dev'])

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
    options = parser.parse(['--environment', 'dev', "--debug"])

    expect(options[:debug]).to eq(true)

    parser = K8s::Templates::Compiler::Options.new
    options = parser.parse(['--environment', 'dev', "-d"])

    expect(options[:debug]).to eq(true)
  end
end
