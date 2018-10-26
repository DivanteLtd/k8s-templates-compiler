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

            opts.on('-d', '--debug', 'Enable debug mode') do |_d|
              @options[:debug] = true
            end

            opts.on('--create', 'Create environment if not exist') do |_c|
              @options[:create] = true
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
              @options[:output_dir] = o
            end

            opts.on('--values [JSON]', 'Environment variables in json format') do |v|
              @options[:values] = v
            end
          end.parse(command_line_args)

          validate

          default_values

          @options
        end
        # rubocop:enable Metrics/MethodLength
        # rubocop:enable Metrics/AbcSize

        protected

        def validate
          validate_environment

          raise OptionParser::InvalidOption, 'values are not valid json' if @options[:values] && JSONHelper.valid_json?(
            @options[:values]
          ) != true
        end

        def validate_environment
          if @options[:environment].nil? && @options[:all_environments] != true
            raise OptionParser::MissingArgument, 'environment'
          end

          raise OptionParser::InvalidOption, 'environment or all_environments' if @options[:environment] && @options[
            :all_environments
          ] == true
        end

        def default_values
          @options[:template_dir] = 'template' unless @options[:template_dir]
          @options[:config_dir] = 'config' unless @options[:config_dir]
          @options[:output_dir] = 'env' unless @options[:output_dir]
        end
      end
    end
  end
end
