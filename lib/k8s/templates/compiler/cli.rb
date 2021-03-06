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
          @environment = nil
        end

        def run(args = ARGV)
          @options = Options.new.parse(args)

          environments(args).each do |environment|
            run_compilation(Environment.new(environment, options))
          end

          STATUS_SUCCESS
        rescue OptionParser::MissingArgument => e
          handle_error(e)
        rescue K8s::Templates::Compiler::Error => e
          handle_error(e)
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

        def run_compilation(environment)
          # For removing files
          @files = []

          templates.each do |template_file|
            filename = File.basename(template_file).gsub('.erb', '')

            puts "Compiling #{filename}" if @options[:debug]

            output = content(template_file, environment)
            next if output.strip.empty?

            write_file(output, template_file, environment)
          end

          remove_old_files(environment)
        end

        def templates
          Dir[template_dir_path + '/**/*.erb']
        end

        def content(template_file, environment)
          contents = File.open(template_file, 'rb').read
          compiler = K8s::Templates::Compiler::Renderer.new
          output = compiler.render(contents, environment)

          output
        end

        def write_file(output, template_file, environment)
          filename = File.basename(template_file).gsub('.erb', '')
          environment_dir_path = environment_dir_path(environment)
          dir_path = environment_dir_path + File.dirname(template_file).gsub(template_dir_path, '')
          file_path = dir_path + '/' + filename

          create_nested_dir(dir_path)
          File.open(file_path, 'w+') do |f|
            f.write(output)
          end

          @files.push << file_path
        end

        def remove_old_files(environment)
          allfiles = Dir[environment_dir_path(environment) + '/*']

          (allfiles - @files).each do |file|
            File.delete(file) if File.file?(file)
          end

          allfiles.each do |file|
            Dir.delete(file) if File.directory?(file) && Dir.empty?(file)
          end
        end

        def create_nested_dir(dir_path)
          FileUtils.mkdir_p(dir_path) unless File.directory?(dir_path)
        end

        def environment_dir_path(environment)
          path = Dir.pwd + '/' + @options[:output_dir] + '/' + environment.name

          unless File.exist?(path)
            raise Error, 'Environment not exists' unless @options[:create]

            FileUtils.mkdir_p(path)
          end

          path
        end

        def template_dir_path
          Dir.pwd + '/' + @options[:template_dir]
        end

        def handle_error(error)
          warn error.message
          warn 'For usage information, use --help'
          STATUS_ERROR
        end
      end
    end
  end
end
