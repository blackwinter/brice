# Configure the IRb prompt

brice 'prompt' => nil do |config|

  class IRB::Context
    %w[prompt_i prompt_s prompt_c prompt_n return_format].each { |name|
      alias_method "_brice_original_#{name}", name

      define_method(name) {
        (v = instance_variable_get("@#{name}")).respond_to?(:call) ? v[
          (t = @_brice_tms) ? '%.4f (%.4f)' % [t.total, t.real] : 'n/a'
        ] : v
      }
    }

    if Object.const_defined?(:Benchmark)
      alias_method :_brice_original_evaluate, :evaluate

      # Capture execution time
      def evaluate(*a)
        @_brice_tms = Benchmark.measure { _brice_original_evaluate(*a) }
      end
    end
  end

  IRB.conf[:PROMPT] ||= {}

  # prompt configuration:
  #
  #   PROMPT_I = normal prompt
  #   PROMPT_S = prompt for continuing strings
  #   PROMPT_C = prompt for continuing statement
  #   RETURN   = format to return value

  prefix = "#{RUBY_VERSION}"
  prefix << "p#{RUBY_PATCHLEVEL}" if defined?(RUBY_PATCHLEVEL)

  prompt_return = Object.const_defined?(:Benchmark) ?
    lambda { |rt| "#{rt} => %s\n" } : "=> %s\n"

  IRB.conf[:PROMPT].update(
    :BRICE_SIMPLE => {
      :PROMPT_I => '  ',
      :PROMPT_S => '  ',
      :PROMPT_C => '  ',
      :RETURN   => prompt_return
    },
    :BRICE_VERBOSE => {
      :PROMPT_I => "#{prefix}> ",
      :PROMPT_S => "#{prefix}> ",
      :PROMPT_C => "#{prefix}> ",
      :RETURN   => prompt_return
    }
  )

  IRB.conf[:PROMPT_MODE] = :BRICE_VERBOSE

end
