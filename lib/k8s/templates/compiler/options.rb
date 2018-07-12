# frozen_string_literal: true

require 'optparse'

module K8s
  module Templates
    module Compiler
      # Options parser
      class Options
        def parse(command_line_args)
          options = {}
          OptionParser.new do |opts|
            opts.banner = "Usage: k8s-templates-compile [options]"

            opts.on("-d", "--debug", "Enable debug mode") do |d|
              options[:debug] = d
            end

            opts.on('-e', '--environment [ENVIRONMENT]', 'Environment name') do |e|
              options[:environment] = e
            end
          end.parse(command_line_args)

          raise OptionParser::MissingArgument.new('environment') if options[:environment].nil?

          options
        end
      end
    end
  end
end
