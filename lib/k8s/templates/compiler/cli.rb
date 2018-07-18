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

          run_compiler

          STATUS_SUCCESS
        rescue OptionParser::MissingArgument => e
          warn e.message
          warn 'For usage information, use --help'
          STATUS_ERROR
        end

        private

        def run_compiler
          templates = Dir[Dir.pwd + '/' + @options[:template_dir] + '/*.erb']

          templates.each do |template_file|
            filename = File.basename(template_file).gsub('.erb', '')

            puts "Compiling #{filename}" if compiler.options[:debug]

            contents = File.open(template_file, 'rb').read
            compiler = K8s::Templates::Compiler::Renderer.new
            output = compiler.render(contents, options)

            next if output.strip.empty?

            file_path = Dir.pwd + '/' + @options[:output_dir] + '/' + filename
            File.open(file_path, 'w+') do |f|
              f.write(output)
            end
          end
        end
      end
    end
  end
end
