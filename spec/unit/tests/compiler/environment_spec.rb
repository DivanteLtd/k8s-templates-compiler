# frozen_string_literal: true

RSpec.describe K8s::Templates::Compiler::Environment do
  context 'initialization process' do
    it 'must have name' do
      expect { K8s::Templates::Compiler::Environment.new }.to raise_error(ArgumentError)
    end

    it 'should return correct env name' do
      env_name = 'test'
      options = { environment: env_name }

      env = K8s::Templates::Compiler::Environment.new(env_name, options)

      expect(env.name).to eq(env_name)
    end
  end

  context 'config directory' do
    it 'should return default config dir' do
      env_name = 'test'
      options = { environment: 'test' }

      env = K8s::Templates::Compiler::Environment.new(env_name, options)

      expect(env.config_dir).to eq('config')
    end

    it 'should return custom config dir' do
      env_name = 'test'
      config_dir = 'custom'
      options = { environment: 'test', config_dir: config_dir }

      env = K8s::Templates::Compiler::Environment.new(env_name, options)

      expect(env.config_dir).to eq(config_dir)
    end
  end

  context 'working with configuration file' do
    it 'should read custom config dir and return as array' do
      env_name = 'test'
      config_dir = 'spec/unit/files/environment'
      options = { environment: 'test', config_dir: config_dir }

      env = K8s::Templates::Compiler::Environment.new(env_name, options)

      expect(env.values[:namespace][:name]).to eq('test')
    end
  end

  context 'working with options' do
    it 'should take config from cli and return as array' do
      env_name = 'test'
      options = { environment: 'test', values: '{ "namespace": { "name": "' + env_name + '" } }' }

      env = K8s::Templates::Compiler::Environment.new(env_name, options)

      expect(env.values[:namespace][:name]).to eq('test')
    end
  end

  context 'working with configuration file and options' do
    it 'should read custom config dir, take config from cli, merge it and return as array' do
      env_name = 'test_2'
      config_dir = 'spec/unit/files/environment'
      options = { environment: 'test', config_dir: config_dir, values: '{"namespace": { "name": "' + env_name + '"} }' }

      env = K8s::Templates::Compiler::Environment.new(env_name, options)

      expect(env.values[:namespace][:name]).to eq(env_name)
    end
  end
end
