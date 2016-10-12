#--
###############################################################################
#                                                                             #
# A component of brice, the extra cool IRb goodness donator                   #
#                                                                             #
# Copyright (C) 2008-2014 Jens Wille                                          #
#                                                                             #
# Authors:                                                                    #
#     Jens Wille <jens.wille@gmail.com>                                       #
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

module Brice

  # Add colour support to IRb.
  #
  # Set your own colours with <tt>config.colours.opt = { colours: { ... } }</tt>
  # or modify the default scheme (DEFAULT_COLOURS) with <tt>config.colours.opt =
  # { colours: Brice::Colours::DEFAULT_COLOURS.merge(...) }</tt>.

  module Colours

    extend self

    # Default IRb colour scheme.
    DEFAULT_COLOURS = {
      # delimiter colours
      comma:              :blue,
      refers:             :blue,

      # container colours (hash and array)
      open_hash:          :green,
      close_hash:         :green,
      open_array:         :green,
      close_array:        :green,

      # object colours
      open_object:        :light_red,
      object_class:       :white,
      object_addr_prefix: :blue,
      object_line_prefix: :blue,
      close_object:       :light_red,

      # symbol colours
      symbol:             :yellow,
      symbol_prefix:      :yellow,

      # string colours
      open_string:        :red,
      string:             :cyan,
      close_string:       :red,

      # misc colours
      number:             :cyan,
      keyword:            :green,
      class:              :light_green,
      range:              :red,
      unknown:            :green
    }

    # Fruity testing colours.
    TESTING_COLOURS = {
      comma:              :red,
      refers:             :red,
      open_hash:          :blue,
      close_hash:         :blue,
      open_array:         :green,
      close_array:        :green,
      open_object:        :light_red,
      object_class:       :light_green,
      object_addr:        :purple,
      object_line:        :light_purple,
      close_object:       :light_red,
      symbol:             :yellow,
      symbol_prefix:      :yellow,
      number:             :cyan,
      string:             :cyan,
      keyword:            :white,
      range:              :light_blue
    }

    def init(opt = {})
      require 'ripper'

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
      IRB::Inspector.class_eval {
        unless method_defined?(:inspect_value_with_colour)
          alias_method :inspect_value_without_colour, :inspect_value

          def inspect_value_with_colour(value)
            Colours.colourize(inspect_value_without_colour(value))
          end
        end

        alias_method :inspect_value, :inspect_value_with_colour
      }
    end

    # Disable colourized IRb results.
    def disable_irb
      IRB::Inspector.class_eval {
        if method_defined?(:inspect_value_without_colour)
          alias_method :inspect_value, :inspect_value_without_colour
        end
      }
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
     ''.tap { |res| Tokenizer.tokenize(str.to_s) { |token, value|
        res << colourize_string(value, colours[token])
      } }
    rescue => err
      Brice.error(self, __method__, err)
      str
    end

    # Terminal escape codes for colours.

    module Colour

      extend self

      COLOURS = {
        reset:         '0;0',
        black:         '0;30',
        red:           '0;31',
        green:         '0;32',
        brown:         '0;33',
        blue:          '0;34',
        cyan:          '0;36',
        purple:        '0;35',
        light_gray:    '0;37',
        dark_gray:     '1;30',
        light_red:     '1;31',
        light_green:   '1;32',
        yellow:        '1;33',
        light_blue:    '1;34',
        light_cyan:    '1;36',
        light_purple:  '1;35',
        white:         '1;37'
      }

      # Return the escape code for a given colour.
      def escape(key)
        "\033[#{COLOURS[key]}m" if COLOURS.key?(key)
      end

      alias_method :[], :escape

    end

    # Tokenize an inspection string.

    class Tokenizer

      EVENT_MAP = {
      # on_CHAR:            :unknown,
      # on___end__:         :unknown,
      # on_backref:         :unknown,
      # on_backtick:        :unknown,
        on_comma:           :comma,
        on_comment:         :unknown,
        on_const:           :class,
      # on_cvar:            :unknown,
      # on_embdoc:          :unknown,
      # on_embdoc_beg:      :unknown,
      # on_embdoc_end:      :unknown,
      # on_embexpr_beg:     :unknown,
      # on_embexpr_end:     :unknown,
      # on_embvar:          :unknown,
        on_float:           :number,
      # on_gvar:            :unknown,
      # on_heredoc_beg:     :unknown,
      # on_heredoc_end:     :unknown,
        on_ident:           :symbol,
      # on_ignored_nl:      :unknown,
        on_imaginary:       :number,
        on_int:             :number,
      # on_ivar:            :unknown,
        on_kw:              :keyword,
        on_label:           :unknown,
        on_lbrace:          :open_hash,
        on_lbracket:        :open_array,
        on_lparen:          :unknown,
      # on_nl:              :unknown,
        on_op:              :refers,
        on_period:          :comma,
      # on_qsymbols_beg:    :unknown,
      # on_qwords_beg:      :unknown,
        on_rational:        :number,
        on_rbrace:          :close_hash,
        on_rbracket:        :close_array,
        on_regexp_beg:      :unknown,
        on_regexp_end:      :unknown,
        on_rparen:          :unknown,
        on_semicolon:       :comma,
        on_sp:              :whitespace,
        on_symbeg:          :symbol_prefix,
      # on_symbols_beg:     :unknown,
      # on_tlambda:         :unknown,
      # on_tlambeg:         :unknown,
        on_tstring_beg:     :open_string,
        on_tstring_content: :string,
        on_tstring_end:     :close_string,
      # on_words_beg:       :unknown,
      # on_words_sep:       :unknown
      }

      OBJECT_RE = %r{
        \A
        ( \#< )
        ( .+ )
        ( > )
        \z
      }x

      OBJECT_CLASS_RE = %r{
        \A
        (?: \w | :: )+
      }x

      OBJECT_ADDR_RE = %r{
        \A
        ( : )
        ( 0x [\hx]+ )
        (?= \s | \z )
      }x

      IVAR_RE = %r{
        \A
        ( @ )
        ( .+ )
        \z
      }x

      RANGE_RE = %r{
        \A
        \.+
        \z
      }x

      def self.tokenize(str, &block)
        new(&block).tokenize(str)
      end

      def initialize(&block)
        @block = block or raise ArgumentError, 'no block given'
      end

      attr_reader :block

      def tokenize(str)
        return if str.empty?
        return if enc_event(str)

        lex, prev = Ripper.lex(str), nil

        len = lex[-1][0][-1] + lex[-1][-1].bytesize
        str, rest = str.byteslice(0, len), str.byteslice(len .. -1)

        return block[:unknown, rest] if str.empty?

        lex.each { |_, event, tok|
          sym_event(event, tok, prev) ||
          obj_event(event, tok)       ||
          rng_event(event, tok)       ||
          var_event(event, tok)       ||
          map_event(event, tok)

          prev = event
        }

        tokenize(rest)
      end

      private

      def enc_event(str)  # XXX /\A\s*#.*?coding\s*:\s*./
        object($1, $2, $3) if str =~ OBJECT_RE && str.include?('coding')
      end

      def obj_event(event, tok)
        object($1, $2, $3) if event == :on_comment && tok =~ OBJECT_RE
      end

      def sym_event(event, tok, prev)
        block[:symbol, tok] if event == :on_kw && prev == :on_symbeg
      end

      def rng_event(event, tok)
        block[:range, tok] if event == :on_op && tok =~ RANGE_RE
      end

      def var_event(event, tok)
        if event == :on_ivar && tok =~ IVAR_RE
          block[:object_line_prefix, $1]
          block[:keyword, $2]
        end
      end

      def map_event(event, tok)
        block[EVENT_MAP[event], tok]
      end

      def object(open, str, close)
        block[:open_object, open]

        if str.sub!(OBJECT_CLASS_RE, '')
          block[:object_class, $&]

          if str.sub!(OBJECT_ADDR_RE, '')
            block[:object_addr_prefix, $1]
            block[:object_addr, $2]

            str = tokenize(str)
          end
        end

        block[:unknown, str] if str

        block[:close_object, close]
      end

    end

  end

end
