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

          run_compilation

          STATUS_SUCCESS
        rescue OptionParser::MissingArgument => e
          warn e.message
          warn 'For usage information, use --help'
          STATUS_ERROR
        end

        private

        def run_compilation
          # For removing files
          @files = []

          templates.each do |template_file|
            filename = File.basename(template_file).gsub('.erb', '')

            puts "Compiling #{filename}" if @options[:debug]

            output = content(template_file)
            next if output.strip.empty?

            write_file(output, filename)
          end

          remove_old_files
        end

        def templates
          Dir[Dir.pwd + '/' + @options[:template_dir] + '/*.erb']
        end

        def content(template_file)
          contents = File.open(template_file, 'rb').read
          compiler = K8s::Templates::Compiler::Renderer.new
          output = compiler.render(contents, @options)

          output
        end

        def write_file(output, filename)
          file_path = Dir.pwd + '/' + @options[:output_dir] + '/' + filename

          File.open(file_path, 'w+') do |f|
            f.write(output)
          end

          @files.push << file_path
        end

        def remove_old_files
          allfiles = Dir[Dir.pwd + '/' + @options[:output_dir] + '/*']

          (allfiles - @files).each do |file|
            File.delete(file)
          end
        end
      end
    end
  end
end
