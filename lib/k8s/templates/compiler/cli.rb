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

          environments(args).each do |environment|
            options_for_environment(args, environment)
            run_compilation
          end

          STATUS_SUCCESS
        rescue OptionParser::MissingArgument => e
          warn e.message
          warn 'For usage information, use --help'
          STATUS_ERROR
        end

        private

        def environments(args)
          environments = if args.include?('--all-environments')
                           environments_from_config_dir
                         else
                           [@options[:environment]]
                         end

          args.delete('--all-environments')

          environments
        end

        def environments_from_config_dir
          environments = []

          files = Dir[Dir.pwd + '/' + @options[:config_dir] + '/*']
          files.each do |path|
            environments << path.sub!(Dir.pwd + '/' + @options[:config_dir] + '/', '')
          end

          environments
        end

        def options_for_environment(args, environment)
          puts "Environment: #{environment}" if @options[:debug]

          if environment
            args << '--environment'
            args << environment
          end

          @options = Options.new.parse(args)
        end

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
          file_path = Dir.pwd + '/' + @options[:output_dir] + '/' + @options[:environment] + '/' + filename

          File.open(file_path, 'w+') do |f|
            f.write(output)
          end

          @files.push << file_path
        end

        def remove_old_files
          allfiles = Dir[Dir.pwd + '/' + @options[:output_dir] + '/' + @options[:environment] + '/*']

          (allfiles - @files).each do |file|
            File.delete(file)
          end
        end
      end
    end
  end
end
