# frozen_string_literal: true

module K8s
  module Templates
    module Compiler
      # Command Line Interface
      class Cli
        attr_reader :options

        STATUS_SUCCESS  = 0
        STATUS_ERROR    = 1

        def initialize
          @options = {}
        end

        def run(args = ARGV)
          @options = Options.new.parse(args)

          STATUS_SUCCESS
        rescue OptionParser::MissingArgument => e
          warn e.message
          warn 'For usage information, use --help'
          STATUS_ERROR
        end
      end
    end
  end
end
