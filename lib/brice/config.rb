#--
###############################################################################
#                                                                             #
# A component of brice, the extra cool IRb goodness donator                   #
#                                                                             #
# Copyright (C) 2008-2011 Jens Wille                                          #
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

require 'ostruct'
require 'brice'

module Brice

  # Exclude unwanted packages:
  #
  #   config.exclude 'foo', 'bar'
  #   Brice.config -= %w[quix quux]
  #
  # Include non-default packages:
  #
  #   config.include 'foo', 'bar'
  #   Brice.config += %w[quix quux]
  #
  # Configure individual packages (depends on package):
  #
  #   # set property
  #   config.foo.bar = 'baz'
  #
  #   # set multiple properties
  #   config.foo = %w[bar baz]
  #   # which is equivalent to:
  #   config.foo.bar = true
  #   config.foo.baz = true
  #
  #   # reset package configuration
  #   config.foo!
  #
  #   # see whether package is enabled/included
  #   config.foo?

  class Config

    attr_reader :packages

    def initialize(packages = [])
      @packages = Hash.new { |h, k| h[k] = PackageConfig.new }
      packages.each { |package| self[package] }
    end

    # call-seq:
    #   config[package]
    #
    # Accessor for package +package+.
    def [](package)
      packages[package.to_s]
    end

    # call-seq:
    #   config.include(*packages)
    #   config += packages
    #
    # Enable/include packages +packages+.
    def include(*packages)
      packages.each { |package| self[package] }
      self
    end

    alias_method :+, :include

    # call-seq:
    #   config.exclude(*packages)
    #   config -= packages
    #
    # Disable/exclude packages +packages+.
    def exclude(*packages)
      packages.each { |package| self.packages.delete(package.to_s) }
      self
    end

    alias_method :-, :exclude

    # call-seq:
    #   config.clear
    #
    # Clear all packages.
    def clear
      packages.clear
    end

    # call-seq:
    #   config.include?(package) => true or false
    #   config.have?(package) => true or false
    #
    # See whether package +package+ is enabled/included.
    def include?(package)
      packages.include?(package.to_s)
    end

    alias_method :have?, :include?

    # call-seq:
    #   config.package                # package configuration
    #   config.package = 'foo'        # equivalent to: config.package.foo = true
    #   config.package = %w[foo bar]  # see above, multiple
    #   config.package!               # reset package configuration
    #   config.package?               # see whether package is enabled/included
    #
    # Convenience accessors to individual package configurations.
    def method_missing(method, *args)
      package, punctuation = method.to_s.sub(/([=!?])?\z/, ''), $1

      assignment = punctuation == '='

      unless assignment || args.empty?
        raise ArgumentError, "wrong number of arguments (#{args.size} for 0)"
      end

      case punctuation
        when '=', '!'
          config = packages[package] = PackageConfig.new

          assignment ? Array(args.first).each { |arg|
            config.send("#{arg}=", true)
          } : config
        when '?'
          include?(package)
        else
          self[package]
      end
    end

    class PackageConfig < OpenStruct

      include Enumerable

      # call-seq:
      #   pkgconfig.each { |entry| ... } -> pkgconfig
      #
      # Iterates over all entries in +pkgconfig+. Returns +pkgconfig+.
      def each
        @table.keys.each { |key| yield key.to_s }
        self
      end

      # call-seq:
      #   pkgconfig.empty? -> true | false
      #
      # Checks whether +pkgconfig+ is empty?
      def empty?
        @table.empty?
      end

    end

  end

end
