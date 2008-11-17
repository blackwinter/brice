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

  module DSL

    def irb_rc
      Brice.irb_rc << Proc.new
    end

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

    def silence
      verbose, $VERBOSE = $VERBOSE, nil

      yield
    ensure
      $VERBOSE = verbose
    end

    def brice_rescue(what, args = [], error = Exception)
      res = send(what, *args)

      block_given? ? yield : res
    rescue Exception => err
      raise unless err.is_a?(error)

      unless Brice.quiet
        location = caller.find { |c| c !~ %r{(?:\A|/)lib/brice[/.]} }
        warn "#{err.class}: #{err} [#{location}]"
      end
    end

    def brice_require(string)
      args = [:require, [string], LoadError]

      if block_given?
        brice_rescue(*args) { |*a| yield(*a) }
      else
        brice_rescue(*args)
      end
    end

    def brice_load(filename, wrap = false)
      args = [:load, [filename, wrap]]

      if block_given?
        brice_rescue(*args) { |*a| yield(*a) }
      else
        brice_rescue(*args)
      end
    end

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
