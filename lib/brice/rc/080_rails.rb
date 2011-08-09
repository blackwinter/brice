# Rails settings (cf. <http://www.quotedprintable.com/2007/9/13/my-irbrc>)

brice 'rails' => nil do |config|

  if rails_env = ENV['RAILS_ENV']
    ### prompt
    hint = rails_env == 'development' ? '' : "@#{rails_env}"

    svn = brice_require('nuggets/file/which') { File.which('svn') }

    if svn and svn_info = YAML.load(brice_run_cmd("#{svn} info 2> /dev/null", 'LANG' => 'C'))
      repo = svn_info['Repository Root']
      path = svn_info['URL'].sub(%r{#{Regexp.escape(repo)}/?}, '')

      prompt = File.basename(repo) << hint
      prompt << " [#{path}]" unless path.empty?
    else
      prompt = File.basename(Dir.pwd) << hint
    end

    # add "ENV['RAILS_SANDBOX'] = 'true'" in rails/lib/commands/console.rb
    prompt << "#{ENV['RAILS_SANDBOX'] ? '>' : '$'} "

    IRB.conf[:PROMPT] ||= {}

    IRB.conf[:PROMPT][:BRICE_RAILS] = {
      :PROMPT_I => prompt,
      :PROMPT_S => prompt,
      :PROMPT_C => prompt,
      :RETURN   => IRB.conf[:PROMPT][:BRICE_SIMPLE] ?
        IRB.conf[:PROMPT][:BRICE_SIMPLE][:RETURN] : "=> %s\n"
    }

    IRB.conf[:PROMPT_MODE] = :BRICE_RAILS

    ### logger
    brice_require 'logger' do

      silence {
        Object.const_set(:RAILS_DEFAULT_LOGGER, Logger.new(STDOUT))
      }

      define_irb_method(:logger) { |*args|
        if args.empty?
          RAILS_DEFAULT_LOGGER
        else
          level, previous_level = args.first, logger.level

          logger.level = level.is_a?(Integer) ?
            level : Logger.const_get(level.to_s.upcase)

          if block_given?
            begin
              yield  # RDoc: Warning: yield outside of method
            ensure
              logger.level = previous_level
            end
          else
            logger
          end
        end
      }

    end

    # people/6 ;-) ...inspired by:
    # <http://github.com/xaviershay/dotfiles/tree/master/irbrc>
    define_irb_method(:method_missing) { |method, *args|
      begin
        klass = method.to_s.classify.constantize

        unless klass.respond_to?(:/)
          if klass.respond_to?(:[])
            class << klass; alias_method :/, :[]; end
          else
            class << klass; alias_method :/, :find; end
          end
        end

        klass
      rescue NameError
        super
      end
    }
  end

end
