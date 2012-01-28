#--
###############################################################################
#                                                                             #
# A component of brice, the extra cool IRb goodness donator                   #
#                                                                             #
# Copyright (C) 2008-2012 Jens Wille                                          #
#                                                                             #
# Authors:                                                                    #
#     Jens Wille <jens.wille@uni-koeln.de>                                    #
#                                                                             #
# brice is free software: you can redistribute it and/or modify it under the  #
# terms of the GNU Affero General Public License as published by the Free     #
# Software Foundation, either version 3 of the License, or (at your option)   #
# any later version.                                                          #
#                                                                             #
# brice is distributed in the hope that it will be useful, but WITHOUT ANY    #
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS   #
# FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for     #
# more details.                                                               #
#                                                                             #
# You should have received a copy of the GNU Affero General Public License    #
# along with brice. If not, see <http://www.gnu.org/licenses/>.               #
#                                                                             #
###############################################################################
#++

require 'brice'

module Brice

  # Add colour support to IRb.
  #
  # Set your own colours with <tt>config.colours.opt = { :colours => { ... } }</tt>
  # or modify the default scheme (DEFAULT_COLOURS) with <tt>config.colours.opt =
  # { :colours => Brice::Colours::DEFAULT_COLOURS.merge(...) }</tt>.

  module Colours

    extend self

    # Default IRb colour scheme.
    DEFAULT_COLOURS = {
      # delimiter colours
      :comma              => :blue,
      :refers             => :blue,

      # container colours (hash and array)
      :open_hash          => :green,
      :close_hash         => :green,
      :open_array         => :green,
      :close_array        => :green,

      # object colours
      :open_object        => :light_red,
      :object_class       => :white,
      :object_addr_prefix => :blue,
      :object_line_prefix => :blue,
      :close_object       => :light_red,

      # symbol colours
      :symbol             => :yellow,
      :symbol_prefix      => :yellow,

      # string colours
      :open_string        => :red,
      :string             => :cyan,
      :close_string       => :red,

      # misc colours
      :number             => :cyan,
      :keyword            => :green,
      :class              => :light_green,
      :range              => :red,
      :unknown            => :green
    }

    # Fruity testing colours.
    TESTING_COLOURS = {
      :comma            => :red,
      :refers           => :red,
      :open_hash        => :blue,
      :close_hash       => :blue,
      :open_array       => :green,
      :close_array      => :green,
      :open_object      => :light_red,
      :object_class     => :light_green,
      :object_addr      => :purple,
      :object_line      => :light_purple,
      :close_object     => :light_red,
      :symbol           => :yellow,
      :symbol_prefix    => :yellow,
      :number           => :cyan,
      :string           => :cyan,
      :keyword          => :white,
      :range            => :light_blue
    }

    def init(opt = {})
      enable_irb if Brice.opt(opt, :irb, STDOUT.tty?)
      enable_pp  if Brice.opt(opt, :pp,  STDOUT.tty?)

      self.colours = Brice.opt(opt, :colours, colours)
    end

    def disable
      disable_irb
      disable_pp
    end

    # Enable colourized IRb results.
    def enable_irb
      if IRB.const_defined?(:Inspector)
        IRB::Inspector.class_eval {
          unless method_defined?(:inspect_value_with_colour)
            alias_method :inspect_value_without_colour, :inspect_value

            def inspect_value_with_colour(value)
              Colours.colourize(inspect_value_without_colour(value))
            end
          end

          alias_method :inspect_value, :inspect_value_with_colour
        }
      else
        IRB::Irb.class_eval {
          unless method_defined?(:output_value_with_colour)
            alias_method :output_value_without_colour, :output_value

            def output_value_with_colour
              value = @context.last_value
              value = Colours.colourize(value.inspect) if @context.inspect?

              printf(@context.return_format, value)
            end
          end

          alias_method :output_value, :output_value_with_colour
        }
      end
    end

    # Disable colourized IRb results.
    def disable_irb
      if IRB.const_defined?(:Inspector)
        IRB::Inspector.class_eval {
          if method_defined?(:inspect_value_without_colour)
            alias_method :inspect_value, :inspect_value_without_colour
          end
        }
      else
        IRB::Irb.class_eval {
          if method_defined?(:output_value_without_colour)
            alias_method :output_value, :output_value_without_colour
          end
        }
      end
    end

    def enable_pp
      require 'pp'

      class << PP
        unless method_defined?(:pp_with_colour)
          alias_method :pp_without_colour, :pp

          def pp_with_colour(obj, out = $>, width = 79)
            res = pp_without_colour(obj, str = '', width)
            out << Colours.colourize(str)
            res
          end

          alias_method :pp, :pp_with_colour
        end

        unless method_defined?(:singleline_pp_with_colour)
          alias_method :singleline_pp_without_colour, :singleline_pp

          def singleline_pp_with_colour(obj, out = $>)
            res = singleline_pp_without_colour(obj, str = '')
            out << Colours.colourize(str)
            res
          end

          alias_method :singleline_pp, :singleline_pp_with_colour
        end
      end
    end

    def disable_pp
      PP.class_eval {
        if method_defined?(:pp_without_colour)
          alias_method :pp, :pp_without_colour
        end

        if method_defined?(:singleline_pp_without_colour)
          alias_method :singleline_pp, :singleline_pp_without_colour
        end
      }
    end

    # Set colour map to hash
    def colours=(hash)
      @colours = hash
    end

    # Get current colour map
    def colours
      @colours ||= DEFAULT_COLOURS.dup
    end

    # Return a string with the given colour.
    def colourize_string(str, colour)
      (col = Colour[colour]) ? "#{col}#{str}#{Colour[:reset]}" : str
    end

    # Colourize the results of inspect
    def colourize(str)
      res = ''

      Tokenizer.tokenize(str) { |token, value|
        res << colourize_string(value, colours[token])
      }

      res
    rescue
      str
    end

    # Terminal escape codes for colours.

    module Colour

      extend self

      COLOURS = {
        :reset        => '0;0',
        :black        => '0;30',
        :red          => '0;31',
        :green        => '0;32',
        :brown        => '0;33',
        :blue         => '0;34',
        :cyan         => '0;36',
        :purple       => '0;35',
        :light_gray   => '0;37',
        :dark_gray    => '1;30',
        :light_red    => '1;31',
        :light_green  => '1;32',
        :yellow       => '1;33',
        :light_blue   => '1;34',
        :light_cyan   => '1;36',
        :light_purple => '1;35',
        :white        => '1;37'
      }

      # Return the escape code for a given colour.
      def escape(key)
        "\033[#{COLOURS[key]}m" if COLOURS.has_key?(key)
      end

      alias_method :[], :escape

    end

    # Tokenize an inspection string.

    module Tokenizer

      extend self

      def tokenize(str)
        raise ArgumentError, 'no block given' unless block_given?

        chars = str.split(//)
        char  = last_char = repeat = nil
        states, value, index = [], '', 0

        reset = lambda { |*args|
          states.pop

          value  = ''
          repeat = args.first unless args.empty?
        }

        yield_last = lambda { |*args|
          yield states.last, value
          reset[*args]
        }

        until index > chars.size
          char, repeat = chars[index], false

          case states.last
            when nil
              case char
                when ':' then states << :symbol
                when '"' then states << :string
                when '#' then states << :object
                when /[a-z]/i
                  states << :keyword
                  repeat = true
                when /[0-9-]/
                  states << :number
                  repeat = true
                when '{'  then yield :open_hash,   '{'
                when '['  then yield :open_array,  '['
                when ']'  then yield :close_array, ']'
                when '}'  then yield :close_hash,  '}'
                when /\s/ then yield :whitespace,  char
                when ','  then yield :comma,       ','
                when '>'  then yield :refers,      '=>' if last_char == '='
                when '.'  then yield :range,       '..' if last_char == '.'
                when '='  then nil
                else           yield :unknown,     char
              end
            when :symbol
              if char =~ /[a-z0-9_!?]/  # should have =, but that messes up foo=>bar
                value << char
              else
                yield :symbol_prefix, ':'
                yield_last[true]
              end
            when :string
              if char == '"'
                if last_char == '\\'
                  value[-1] = char
                else
                  yield :open_string,  char
                  yield_last[]
                  yield :close_string, char
                end
              else
                value << char
              end
            when :keyword
              if char =~ /[a-z0-9_]/i
                value << char
              else
                states[-1] = :class if value =~ /\A[A-Z]/
                yield_last[true]

                value << char if char == '.'
              end
            when :number
              case char
                when /[0-9e-]/
                  value << char
                when '.'
                  if last_char == char
                    value.chop!

                    yield_last[]
                    yield :range, '..'
                  else
                    value << char
                  end
                else
                  yield_last[true]
              end
            when :object
              case char
                when '<'
                  yield :open_object, '#<'
                  states << :object_class
                when ':'
                  states << :object_addr
                when '@'
                  states << :object_line
                when '>'
                  yield :close_object, '>'
                  reset[]
              end
            when :object_class
              if char == ':'
                yield_last[true]
              else
                value << char
              end
            when :object_addr
              case char
                when '>'
                  # ignore
                when '@'
                  yield :object_addr_prefix, ':'
                  yield_last[true]
                else
                  value << char
              end
            when :object_line
              if char == '>'
                yield :object_line_prefix, '@'
                yield_last[true]
              else
                value << char
              end
            else
              raise "unknown state: #{states}"
          end

          unless repeat
            index += 1
            last_char = char
          end
        end
      end

    end

  end

end
