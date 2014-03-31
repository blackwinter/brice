#--
###############################################################################
#                                                                             #
# brice -- Extra cool IRb goodness for the masses                             #
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

require 'irb'
require 'nuggets/env/user_home'

require 'brice/version'

module Brice

  autoload :Config,    'brice/config'
  autoload :Colours,   'brice/colours'
  autoload :DSL,       'brice/dsl'
  autoload :History,   'brice/history'
  autoload :Shortcuts, 'brice/shortcuts'

  RC_DIR = __FILE__.sub(/\.rb\z/, '/rc')

  BRICE_HOME = File.join(ENV.user_home, '.brice')

  @verbose = false
  @quiet   = true

  extend self
  include DSL

  attr_reader :config, :irb_rc

  attr_accessor :verbose, :quiet

  # call-seq:
  #   Brice.init { |config| ... }
  #   Brice.init(:verbose => true) { |config| ... }
  #
  # Initialize Brice and optionally configure any packages.
  def init(options = {})
    @irb_rc = []

    @config = Config.new(rc_files(true).map { |rc|
      File.basename(rc, '.rb').sub(/\A\d+_/, '')
    })

    options.each { |key, value|
      if respond_to?(method = "#{key}=")
        send(method, value)
      else
        raise ArgumentError, "illegal option: #{key}"
      end
    }

    yield config if block_given?

    load_rc_files(true)
    finalize_irb_rc!

    config
  end

  # call-seq:
  #   Brice.config = config
  #
  # Set config to +config+. Raises a TypeError if +config+ is not a
  # Brice::Config.
  def config=(config)
    if config.is_a?(Config)
      @config = config
    else
      raise TypeError, "expected Brice::Config, got #{config.class}"
    end
  end

  # call-seq:
  #   Brice.include?(package) => true or false
  #   Brice.have?(package) => true or false
  #
  # See whether package +package+ is enabled/included.
  def include?(package)
    config.include?(package)
  end

  alias_method :have?, :include?

  # call-seq:
  #   Brice.rc_files(include_custom_extensions = false) => anArray
  #
  # Get the extension files, optionally including custom extensions
  # if +include_custom_extensions+ is true.
  def rc_files(include_custom_extensions = false)
    @rc_files ||= find_rc_files
    include_custom_extensions ? @rc_files + custom_extensions : @rc_files
  end

  # call-seq:
  #   Brice.custom_extensions => anArray
  #
  # Get the custom extension files.
  def custom_extensions
    @custom_extensions ||= find_rc_files(BRICE_HOME)
  end

  # call-seq:
  #   Brice.opt(opt, key, default = true) -> anObject
  #
  # Returns the value of +opt+ at +key+ if present, or +default+
  # otherwise.
  def opt(opt, key, default = true)
    opt.is_a?(Hash) && opt.has_key?(key) ? opt[key] : default
  end

  private

  # call-seq:
  #   load_rc_files(include_custom_extensions = false) => anArray
  #
  # Load the extension files, optionally including custom extensions
  # if +include_custom_extensions+ is true.
  def load_rc_files(include_custom_extensions = false)
    Object.send(:include, DSL)

    res = rc_files.each { |rc|
      warn "Loading #{rc}..." if verbose
      brice_load rc
    }

    include_custom_extensions ? res + load_custom_extensions : res
  end

  # call-seq:
  #   load_custom_extensions => anArray
  #
  # Load the custom extension files.
  def load_custom_extensions
    custom_extensions.each { |rc|
      warn "Loading custom #{rc}..." if verbose
      brice_load rc
    }
  end

  # call-seq:
  #   find_rc_files(dir = ...) => anArray
  #
  # Find the actual extension files in +dir+.
  def find_rc_files(dir = RC_DIR)
    File.directory?(dir) ? Dir["#{dir}/**/*.rb"].sort : []
  end

  # call-seq:
  #   finalize_irb_rc! => aProc
  #
  # Generate proc for IRB_RC from all added procs.
  def finalize_irb_rc!
    IRB.conf[:IRB_RC] = lambda { |context|
      irb_rc.each { |rc| rc[context] }
    } unless irb_rc.empty?
  end

end
