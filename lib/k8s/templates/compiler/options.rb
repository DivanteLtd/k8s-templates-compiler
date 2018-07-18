# frozen_string_literal: true

require 'optparse'
require 'yaml'

module K8s
  module Templates
    module Compiler
      # Options parser
      class Options
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

            opts.on('-t', '--template [PATH]', 'Path to directory with template files. Default: ./template') do |t|
              @options[:template_dir] = t
            end

            opts.on('-c', '--config [PATH]', 'Path to directory with config files for environment. Default: ./config') do |c|
              @options[:config_dir] = c
            end
          end.parse(command_line_args)

          raise OptionParser::MissingArgument, 'environment' if @options[:environment].nil?

          @options[:template_dir] = 'template' unless @options[:template_dir]
          @options[:config_dir] = 'config' unless @options[:config_dir]

          parse_project_vars

          @options
        end

        protected

        def parse_project_vars()
          values = {}
          
          config_file = Dir.pwd + '/' + @options[:config_dir] + '/' + @options[:environment] + '/values.yml'
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
