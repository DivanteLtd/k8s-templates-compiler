# frozen_string_literal: true

RSpec.describe K8s::Templates::Compiler::Options do
  it 'has method parse' do
    expect(K8s::Templates::Compiler::Options.method_defined?(:parse)).to eq(true)
  end

  it 'return array' do
    compiler = K8s::Templates::Compiler::Options.new
    expect(compiler.parse.is_a?(Array)).to eq(true)
  end

  it 'has debug mode' do
    args = ["--debug"]
    parser = K8s::Templates::Compiler::Options.new
    options = parser.parse(args)

    expect(options[:debug]).to eq(true)

    args = ["-d"]
    parser = K8s::Templates::Compiler::Options.new
    options = parser.parse(args)

    expect(options[:debug]).to eq(true)
  end
end
