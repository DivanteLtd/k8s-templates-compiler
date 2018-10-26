# frozen_string_literal: true

RSpec.describe K8s::Templates::Compiler do
  before do
    @tmp_dir = SPEC_ROOT_DIR + '/../.tmp'
    @config_dir = '.tmp/config'
    @output_dir = '.tmp/env'
    @test_config_dir = @tmp_dir + '/config'
    @test_output_dir = @tmp_dir + '/env'

    FileUtils.mkdir_p(@test_config_dir)
  end

  context 'compile one existing env' do
    it 'shoule retun env not exists error without --create option' do
      env = 'dev'

      compiler = K8s::Templates::Compiler::Cli.new

      expect do
        compiler.run(
          [
            '-e', env,
            '-t', 'spec/integration/files/template',
            '-c', @config_dir,
            '-o', @output_dir,
            '--values', '{"namespace": {"name": "dev"}, ' \
              '"pv": {"mysql": {"storage_class_name": "manual", "storage": "5Gi", "access_modes": "ReadWriteMany"}},' \
              '"resources": {"mysql": {"limits": ' \
                '{"cpu": "1000m", "memory": "1024Mi"}, "requests": {"cpu": "100m", "memory": "128Mi"}}}}'
          ]
        )
      end.to output(/Environment not exists/).to_stderr
    end

    it 'should create env manifests' do
      env = 'dev'

      compiler = K8s::Templates::Compiler::Cli.new

      compiler.run(
        [
          '-e', env,
          '--create',
          '-t', 'spec/integration/files/template',
          '-c', @config_dir,
          '-o', @output_dir,
          '--values', '{"namespace": {"name": "dev"}, ' \
            '"pv": {"mysql": {"storage_class_name": "manual", "storage": "5Gi", "access_modes": "ReadWriteMany"}},' \
            '"resources": {"mysql": {"limits": ' \
              '{"cpu": "1000m", "memory": "1024Mi"}, "requests": {"cpu": "100m", "memory": "128Mi"}}}}'
        ]
      )

      expect(File.exist?(@test_output_dir + '/' + env + '/00-project.ns.yaml')).to be true
      expect(File.exist?(@test_config_dir + '/' + env + '/values.yaml')).to be true
    end
  end

  after do
    FileUtils.rm_r(@tmp_dir)
  end
end
