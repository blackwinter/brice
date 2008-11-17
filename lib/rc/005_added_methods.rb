# Load Util::AddedMethods[http://prometheus.rubyforge.org/ruby-nuggets/classes/Util/AddedMethods.html]
# from ruby-nuggets[http://prometheus.rubyforge.org/ruby-nuggets/] if one (or both) of the following
# environment variables has been set:
#
# <tt>WATCH_FOR_ADDED_METHODS</tt>::    Regular expression or <tt>true</tt>
# <tt>WATCH_FOR_ADDED_METHODS_IN</tt>:: Space-delimited list of class names

brice 'added_methods' => 'nuggets/util/added_methods' do |config|

  regexp  = ENV['WATCH_FOR_ADDED_METHODS']
  klasses = ENV['WATCH_FOR_ADDED_METHODS_IN']

  if regexp || klasses
    if regexp == 'true'
      Util::AddedMethods.init
    else
      regexp  = Regexp.new(regexp || '')
      klasses = (klasses || '').split

      Util::AddedMethods.init(regexp, klasses)
    end
  end

end
