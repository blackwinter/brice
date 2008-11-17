#--
###############################################################################
#                                                                             #
# brice -- Extra cool IRb goodness for the masses                             #
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

require 'irb'
require 'rubygems'
require 'nuggets/env/user_home'

%w[config dsl version].each { |lib|
  lib = "brice/#{lib}"
  require lib
}

class Brice

  BRICE_HOME = File.join(ENV.user_home, '.brice')

  @verbose = false
  @quiet   = false

  class << self

    include DSL

    attr_reader :config, :irb_rc

    attr_accessor :verbose, :quiet

    def init(options = {})
      @irb_rc = []
      @config = Config.new(rc_files.map { |rc|
        File.basename(rc, '.rb').sub(/\A\d+_/, '')
      })

      options.each { |key, value|
        method = "#{key}="

        if respond_to?(method)
          send(method, value)
        else
          raise ArgumentError, "illegal option: #{key}"
        end
      }

      yield config if block_given?

      load_rc_files
      load_custom_extensions
      finalize_irb_rc

      config
    end

    def config=(config)
      raise TypeError, "expected Brice::Config, got #{config.class}" \
        unless config.is_a?(Config)

      @config = config
    end

    def include?(package)
      config.include?(package)
    end

    def load_rc_files
      Object.send(:include, DSL)

      rc_files.each { |rc|
        warn "Loading #{rc}..." if verbose
        brice_load rc
      }
    end

    def load_custom_extensions
      custom_extensions.each { |rc|
        warn "Loading custom #{rc}..." if verbose
        brice_load rc
      }
    end

    def rc_files
      @rc_files ||= find_rc_files
    end

    def custom_extensions
      @custom_extensions ||= find_rc_files(BRICE_HOME)
    end

    private

    def find_rc_files(dir = File.join(File.dirname(__FILE__), 'rc'))
      File.directory?(dir) ? Dir["#{dir}/*.rb"].sort : []
    end

    def finalize_irb_rc
      IRB.conf[:IRB_RC] = lambda { |context|
        irb_rc.each { |rc| rc[context] }
      } unless irb_rc.empty?
    end

  end

end
