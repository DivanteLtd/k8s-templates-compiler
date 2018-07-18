# frozen_string_literal: true

RSpec.describe K8s::Templates::Compiler do
  it 'has a version number' do
    expect(K8s::Templates::Compiler::VERSION).not_to be nil
  end
end
