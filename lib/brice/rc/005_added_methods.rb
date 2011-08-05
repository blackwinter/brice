# Load AddedMethods[http://added_methods.rubyforge.org/] if one
# (or both) of the following environment variables has been set:
#
# <tt>WATCH_FOR_ADDED_METHODS</tt>::    Regular expression or <tt>true</tt>
# <tt>WATCH_FOR_ADDED_METHODS_IN</tt>:: Space-delimited list of class names

brice 'added_methods' do |config|

  regexp  = ENV['WATCH_FOR_ADDED_METHODS']
  klasses = ENV['WATCH_FOR_ADDED_METHODS_IN']

  if regexp || klasses
    if regexp == 'true'
      AddedMethods.init
    else
      regexp  = Regexp.new(regexp || '')
      klasses = (klasses || '').split

      AddedMethods.init(regexp, klasses)
    end
  end

end
