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

require 'brice'

module Brice

  # Convenient shortcut methods.
  module Shortcuts

    extend self

    def init(opt = {})
      init_object if Brice.opt?(opt, :object)
      init_ri     if Brice.opt?(opt, :ri)
    end

    def init_object
      Object.send(:include, ObjectShortcuts)
    end

    def init_ri
      Module.class_eval {
        def ri(*args)
          ri!('--no-pager', *args)
        end

        def ri!(*args)
          opts, args = args.partition { |arg| arg.to_s =~ /\A--/ }

          args.empty? ? args << name : args.map! { |arg|
            arg, method = arg.to_s, nil

            delim = [['#', :instance_method], ['::', :method]].find { |i, m|
              match  = arg.sub!(/\A#{i}/, '')
              method = begin; send(m, arg); rescue NameError; end

              break i if match || method
            } or next arg

            "#{method && method.to_s[/\((\w+)\)/, 1] || name}#{delim}#{arg}"
          }

          system('ri', *opts.concat(args))
        end
      }

      instance_eval {
        def ri(*args);  Kernel.ri(*args);  end
        def ri!(*args); Kernel.ri!(*args); end
      }
    end

    module ObjectShortcuts

      # Print object methods, sorted by name. (excluding methods that
      # exist in the class Object)
      def po(obj = self)
        obj.methods.sort - Object.methods
      end

      # Print object constants, sorted by name.
      def poc(obj = self)
        obj.constants.sort if obj.respond_to?(:constants)
      end

      # Cf. <http://rubyforge.org/snippet/detail.php?type=snippet&id=22>
      def aorta(obj = self)
        tempfile = Tempfile.new('aorta')
        YAML.dump(obj, tempfile)
        tempfile.close

        path = tempfile.path

        system(ENV['VISUAL'] || ENV['EDITOR'] || 'vi', path)
        return obj unless File.exists?(path)

        content = YAML.load_file(path)
        tempfile.unlink
        content
      end

    end

  end

end
