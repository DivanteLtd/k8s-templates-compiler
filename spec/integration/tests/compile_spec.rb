# frozen_string_literal: true

RSpec.describe K8s::Templates::Compiler do
  before do
    @tmp_dir = SPEC_ROOT_DIR + '/../.tmp'
    @output_dir = '.tmp/env'
    @test_output_dir = @tmp_dir + '/env'

    FileUtils.mkdir_p(@test_output_dir + '/dev')
    FileUtils.mkdir_p(@test_output_dir + '/test')
  end

  context 'compile one existing env' do
    it 'shoule create env manifests' do
      env = 'dev'

      compiler = K8s::Templates::Compiler::Cli.new

      compiler.run(
        [
          '-e', env,
          '-c', 'spec/integration/files/config',
          '-t', 'spec/integration/files/template',
          '-o', @output_dir
        ]
      )

      expect(File.exist?(@test_output_dir + '/' + env + '/00-project.ns.yaml')).to be true
    end
  end

  context 'compile all existing env' do
    it 'shoule create env manifests' do
      compiler = K8s::Templates::Compiler::Cli.new

      compiler.run(
        [
          '--all-environments',
          '-c', 'spec/integration/files/config',
          '-t', 'spec/integration/files/template',
          '-o', @output_dir
        ]
      )

      expect(File.exist?(@test_output_dir + '/dev/00-project.ns.yaml')).to be true
      expect(File.exist?(@test_output_dir + '/test/00-project.ns.yaml')).to be true
    end
  end

  context 'compile env with values from cli' do
    it 'shoule create env manifests' do
      env = 'dev'

      compiler = K8s::Templates::Compiler::Cli.new

      compiler.run(
        [
          '-e', env,
          '-c', 'spec/integration/files/config',
          '-t', 'spec/integration/files/template',
          '--values', '{"pv": {"mysql": {"storage": "10Gi"}}}',
          '-o', @output_dir
        ]
      )

      compiled_file = @test_output_dir + '/' + env + '/40-mysql.pv.yaml'
      expect(File.exist?(compiled_file)).to be true

      data = YAML.load_file(compiled_file)

      expect(data['spec']['capacity']['storage']).to eq '10Gi'
    end
  end

  context 'compile one existing env with nested dir in template dir' do
    it 'shoule create env manifests' do
      env = 'dev'

      compiler = K8s::Templates::Compiler::Cli.new

      compiler.run(
        [
          '-e', env,
          '-c', 'spec/integration/files/config',
          '-t', 'spec/integration/files/template',
          '-o', @output_dir
        ]
      )

      expect(File.exist?(@test_output_dir + '/' + env + '/nested/50-mysql.dep.yaml')).to be true
    end
  end

  after do
    FileUtils.rm_r(@output_dir)
  end
end
