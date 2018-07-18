# frozen_string_literal: true

require 'erb'

module K8s
  module Templates
    module Compiler
      # Renderer based on ERB
      class Renderer
        def render(contents, options)
          b = binding
          b.local_variable_set(:env, options[:environment])
          b.local_variable_set(:values, options[:values])

          renderer = ERB.new(contents, nil, '-')
          output = renderer.result(b)

          output
        end
      end
    end
  end
end
