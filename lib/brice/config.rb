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

require 'ostruct'

class Brice

  class Config

    attr_reader :packages

    def initialize(packages)
      @packages = Hash.new { |h, k| h[k] = PackageConfig.new }
      packages.each { |package| self[package] }
    end

    def [](package)
      packages[package.to_s]
    end

    def include(package)
      self[package]
      self
    end

    alias_method :+, :include

    def exclude(package)
      packages.delete(package.to_s)
      self
    end

    alias_method :-, :exclude

    def clear
      packages.clear
    end

    def include?(package)
      packages.include?(package.to_s)
    end

    def method_missing(method, *args)
      package, punctuation = method.to_s.sub(/([=!?])?\z/, ''), $1

      raise ArgumentError, "wrong number of arguments (#{args.size} for 0)" \
        unless punctuation == '=' || args.empty?

      case punctuation
        when '='
          @packages[package] = PackageConfig.new
          [*args.first].each { |arg| @packages[package].send("#{arg}=", true) }
        when '!'
          @packages[package] = PackageConfig.new
        when '?'
          self.include?(package)
        else
          self[package]
      end
    end

    class PackageConfig < OpenStruct

      def entries
        instance_variable_get(:@table).keys.map { |key| key.to_s }.sort
      end

    end

  end

end
