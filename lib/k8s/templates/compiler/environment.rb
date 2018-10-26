# frozen_string_literal: true

require 'json'

module K8s
  module Templates
    module Compiler
      # Environment manager
      class Environment
        attr_reader :name, :config_dir

        DEFAULT_CONFIG_DIR = 'config'

        def initialize(name, options = {})
          raise ArgumentError, 'Name is required' unless name

          @name = name
          @config_dir = (options[:config_dir]) || DEFAULT_CONFIG_DIR

          @cli_options = options
        end

        def values
          values_from_file.merge(values_from_cli)
        end

        protected

        def values_from_file
          values = {}

          config_file = Dir.pwd + '/' + @config_dir + '/' + @name + '/values.yaml'
          if File.exist? config_file
            data = YAML.load_file(config_file)
            values = data unless data.nil?
          end

          values
        end

        def values_from_cli
          values = {}

          values = JSON.parse(@cli_options[:values], symbolize_names: true) if @cli_options[:values]

          values
        end
      end
    end
  end
end
