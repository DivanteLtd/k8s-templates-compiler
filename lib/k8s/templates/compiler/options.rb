# frozen_string_literal: true

require 'optparse'
require 'yaml'

module K8s
  module Templates
    module Compiler
      # Options parser
      class Options
        # rubocop:disable Metrics/MethodLength
        # rubocop:disable Metrics/AbcSize
        def parse(command_line_args)
          @options = {}
          OptionParser.new do |opts|
            opts.banner = 'Usage: k8s-templates-compile [options]'

            opts.on('-d', '--debug', 'Enable debug mode') do |d|
              @options[:debug] = d
            end

            opts.on('-e', '--environment [ENVIRONMENT]', 'Environment name') do |e|
              @options[:environment] = e
            end

            opts.on('--all-environments', 'Compile all environments') do |_e|
              @options[:all_environments] = true
            end

            opts.on('-t', '--template [PATH]', 'Path to directory with template files. Default: ./template') do |t|
              @options[:template_dir] = t
            end

            opts.on(
              '-c',
              '--config [PATH]',
              'Path to directory with config files for environment. Default: ./config'
            ) do |c|
              @options[:config_dir] = c
            end

            opts.on('-o', '--output [PATH]', 'Path to directory with rendered files. Default: ./env') do |o|
              @options[:output_dir] = o + '/' + @options[:environment]
            end
          end.parse(command_line_args)

          if @options[:environment].nil? && @options[:all_environments] != true
            raise OptionParser::MissingArgument, 'environment'
          end

          if @options[:environment] && @options[:all_environments] == true
            raise OptionParser::InvalidOption, 'environment or all_environments'
          end

          default_values
          parse_project_vars if @options[:environment]

          @options
        end
        # rubocop:enable Metrics/MethodLength
        # rubocop:enable Metrics/AbcSize

        protected

        def default_values
          @options[:template_dir] = 'template' unless @options[:template_dir]
          @options[:config_dir] = 'config' unless @options[:config_dir]
          @options[:output_dir] = 'env/' + @options[:environment] if !@options[:output_dir] && @options[:environment]
        end

        def parse_project_vars
          values = {}

          config_file = Dir.pwd + '/' + @options[:config_dir] + '/' + @options[:environment] + '/values.yaml'
          if File.exist? config_file
            data = YAML.load_file(config_file)
            values = data unless data.nil?
          end

          @options[:values] = values
        end
      end
    end
  end
end
