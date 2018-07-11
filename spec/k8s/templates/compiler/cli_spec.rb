# frozen_string_literal: true

RSpec.describe K8s::Templates::Compiler::Cli do
  it 'has method run' do
    expect(K8s::Templates::Compiler::Cli.method_defined?(:run)).to eq(true)
  end

  it 'return integer' do
    compiler = K8s::Templates::Compiler::Cli.new
    expect(compiler.run.is_a?(Integer)).to eq(true)
  end
end
