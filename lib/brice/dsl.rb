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

require 'nuggets/object/silence_mixin'
require 'nuggets/env/set'

require 'brice'

module Brice

  # Certain global helper methods for use inside IRb extensions. Also
  # available inside the IRb session.

  module DSL

    include Nuggets::Object::SilenceMixin

    # call-seq:
    #   irb_rc { ... }
    #
    # Add IRB_RC proc (to be executed whenever a (sub-)session is started).
    def irb_rc(&block)
      Brice.irb_rc << block
    end

    # call-seq:
    #   irb_def(symbol) { ... }
    #   irb_def(symbol, method)
    #
    # Define a method for use inside the IRb session.
    def irb_def(symbol, method = nil, &block)
      irb_rc {
        IRB::ExtendCommandBundle.class_eval {
          define_method(symbol, method || block)
        }
      }
    end

    alias_method :define_irb_method, :irb_def

    # call-seq:
    #   brice_rescue(what[, args[, error[, quiet]]])
    #
    # Call +what+ with +args+ and rescue potential +error+, optionally
    # executing block in case of success. Gives a nicer error location
    # instead of the full backtrace. Doesn't warn about any errors when
    # +quiet+ is +true+.
    #
    # Returns either the result of the executed method or of the block.
    def brice_rescue(what, args = [], error = Exception, quiet = Brice.quiet)
      res = send(what, *args)

      block_given? ? yield : res
    rescue Exception => err
      raise unless err.is_a?(error)

      unless quiet
        # FIXME: ideally, we'd want the __FILE__ and __LINE__ of the
        # rc file where the error occurred.
        location = caller.find { |c| c !~ %r{(?:\A|/)lib/brice[/.]} }
        warn "#{err.class}: #{err} [#{location}]"

        warn err.backtrace.map { |line|
          "        from #{line}"
        }.join("\n") if Brice.verbose
      end
    end

    # call-seq:
    #   brice_require(string[, quiet])
    #   brice_require(string[, quiet]) { ... }
    #
    # Kernel#require the library named +string+ and optionally execute
    # the block in case of success. Doesn't warn about load errors when
    # +quiet+ is +true+.
    #
    # Returns either the result of the executed method or of the block.
    def brice_require(string, quiet = Brice.quiet, &block)
      brice_rescue(:require, [string], LoadError, quiet, &block)
    end

    # call-seq:
    #   brice_load(filename[, wrap[, quiet]])
    #   brice_load(filename[, wrap[, quiet]]) { ... }
    #
    # Kernel#load the file named +filename+ with argument +wrap+ and
    # optionally execute the block in case of success. Doesn't warn
    # about load errors when +quiet+ is +true+.
    #
    # Returns either the result of the executed method or of the block.
    def brice_load(filename, wrap = false, quiet = Brice.quiet, &block)
      brice_rescue(:load, [filename, wrap], Exception, quiet, &block)
    end

    # call-seq:
    #   brice_run_cmd(cmd, env = {})
    #
    # Runs +cmd+ with ENV modified according to +env+.
    def brice_run_cmd(cmd, env = {})
      ENV.with(env) { %x{#{cmd}} }
    end

    # call-seq:
    #   brice(package)  # package == lib
    #   brice(package => lib)
    #   brice(package => [lib, ...])
    #
    # Declare package +package+. Optionally load given libraries (see below)
    # and configure the package if it has been enabled/included.
    #
    # +package+ can be a String which already names the library to be loaded
    # or a Hash of the form <tt>package => lib</tt> or <tt>package => [lib, ...]</tt>.
    def brice(package)
      package, libs = case package
        when Hash
          names = package.keys

          err = names.size > 1 ? "Too many package names: #{names.join(' ')}" :
                names.size < 1 ? 'No package name given' : nil

          raise ArgumentError, err if err

          [names.first, Array(package.values.first)]
        else
          [package, [package]]
      end

      if Brice.include?(package)
        if libs.all? { |lib| !lib || brice_require(lib) { true } }
          yield Brice.config[package] if block_given?
        end
      end
    end

  end

end
