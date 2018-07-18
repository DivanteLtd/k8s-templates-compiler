# frozen_string_literal: true

RSpec.describe K8s::Templates::Compiler::Renderer do
  it 'has method render' do
    expect(K8s::Templates::Compiler::Renderer.method_defined?(:render)).to eq(true)
  end

  it 'return the same string' do
    compiler = K8s::Templates::Compiler::Renderer.new
    contents = '---

apiVersion: "v1"
kind: Namespace
metadata:
  name: zupa
'

    expect(compiler.render(contents, {})).to eq(contents)
  end

  it 'return content filled environment param' do
    options = { environment: 'zupa' }
    contents = '---

apiVersion: "v1"
kind: Namespace
metadata:
  name: <%= env %>
'

    expected = '---

apiVersion: "v1"
kind: Namespace
metadata:
  name: zupa
'
    compiler = K8s::Templates::Compiler::Renderer.new
    expect(compiler.render(contents, options)).to eq(expected)
  end

  it 'return content filled params from config file' do
    options = { environment: 'zupa', values: { namespace: { name: 'zupa' } } }
    contents = '---

apiVersion: "v1"
kind: Namespace
metadata:
  name: <%= values[:namespace][:name] %>
'

    expected = '---

apiVersion: "v1"
kind: Namespace
metadata:
  name: zupa
'
    compiler = K8s::Templates::Compiler::Renderer.new
    expect(compiler.render(contents, options)).to eq(expected)


  end
end
 