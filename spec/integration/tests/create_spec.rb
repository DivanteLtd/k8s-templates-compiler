# frozen_string_literal: true

RSpec.describe K8s::Templates::Compiler do
  before do
    @envs_dir = SPEC_ROOT_DIR + '/integration/files/env'
  end

  context 'compile one existing env' do
    it 'shoule create env manifests' do
      env = 'dev'
      output_dir = 'spec/integration/files/env'

      compiler = K8s::Templates::Compiler::Cli.new

      compiler.run(
        [
          '-e', env,
          '--create',
          '-t', 'spec/integration/files/template',
          '-o', output_dir,
          '--values', '{"namespace": {"name": "dev"}, ' \
            '"pv": {"mysql": {"storage_class_name": "manual", "storage": "5Gi", "access_modes": "ReadWriteMany"}},' \
            '"resources": {"mysql": {"limits": ' \
              '{"cpu": "1000m", "memory": "1024Mi"}, "requests": {"cpu": "100m", "memory": "128Mi"}}}}',
          '--debug'
        ]
      )

      expect(File.exist?(output_dir + '/' + env + '/00-project.ns.yaml')).to be true
    end
  end

  after do
    FileUtils.rm_r(@envs_dir + '/dev')
  end
end
