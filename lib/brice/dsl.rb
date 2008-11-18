#--
###############################################################################
#                                                                             #
# A component of brice, the extra cool IRb goodness donator                   #
#                                                                             #
# Copyright (C) 2008 Jens Wille                                               #
#                                                                             #
# Authors:                                                                    #
#     Jens Wille <jens.wille@uni-koeln.de>                                    #
#                                                                             #
# brice is free software: you can redistribute it and/or modify it under the  #
# terms of the GNU General Public License as published by the Free Software   #
# Foundation, either version 3 of the License, or (at your option) any later  #
# version.                                                                    #
#                                                                             #
# brice is distributed in the hope that it will be useful, but WITHOUT ANY    #
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS   #
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more       #
# details.                                                                    #
#                                                                             #
# You should have received a copy of the GNU General Public License along     #
# with brice. If not, see <http://www.gnu.org/licenses/>.                     #
#                                                                             #
###############################################################################
#++

class Brice

  # Certain global helper methods for use inside IRb extensions. Also
  # available inside the IRb session.

  module DSL

    # call-seq:
    #   irb_rc { ... }
    #
    # Add IRB_RC proc (to be executed whenever a (sub-)session is started).
    def irb_rc
      Brice.irb_rc << Proc.new
    end

    # call-seq:
    #   irb_def(symbol) { ... }
    #   irb_def(symbol, method)
    #
    # Define a method for use inside the IRb session.
    def irb_def(symbol, method = nil)
      irb_rc {
        Object.instance_eval {
          if method
            define_method(symbol, method)
          else
            define_method(symbol, &Proc.new)
          end
        }
      }
    end

    alias_method :define_irb_method, :irb_def

    # call-seq:
    #   silence { ... }
    #
    # Silence warnings for block execution.
    def silence
      verbose, $VERBOSE = $VERBOSE, nil
      yield
    ensure
      $VERBOSE = verbose
    end

    # call-seq:
    #   brice_rescue(what, args = [], error = Exception)
    #
    # Call +what+ with +args+ and rescue potential +error+, optionally
    # executing block in case of success. Gives a nicer error location
    # instead of the full backtrace.
    #
    # Returns either the result of the executed method or of the block.
    def brice_rescue(what, args = [], error = Exception)
      res = send(what, *args)

      block_given? ? yield : res
    rescue Exception => err
      raise unless err.is_a?(error)

      unless Brice.quiet
        # FIXME: ideally, we'd want the __FILE__ and __LINE__ of the
        # rc file where the error occurred.
        location = caller.find { |c| c !~ %r{(?:\A|/)lib/brice[/.]} }
        warn "#{err.class}: #{err} [#{location}]"
      end
    end

    # call-seq:
    #   brice_require(string)
    #
    # Kernel#require the library named +string+ and optionally execute
    # block in case of success.
    #
    # Returns either the result of the executed method or of the block.
    def brice_require(string)
      args = [:require, [string], LoadError]

      if block_given?
        brice_rescue(*args) { |*a| yield(*a) }
      else
        brice_rescue(*args)
      end
    end

    # call-seq:
    #   brice_load(filename, wrap = false)
    #
    # Kernel#load the file named +filename+ and optionally execute
    # block in case of success.
    #
    # Returns either the result of the executed method or of the block.
    def brice_load(filename, wrap = false)
      args = [:load, [filename, wrap]]

      if block_given?
        brice_rescue(*args) { |*a| yield(*a) }
      else
        brice_rescue(*args)
      end
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
          raise ArgumentError, "Too many package names: #{package.keys.join(' ')}" \
            if package.size > 1
          raise ArgumentError, 'No package name given' \
            if package.size < 1

          [package.keys.first, [*package.values.first]]
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
