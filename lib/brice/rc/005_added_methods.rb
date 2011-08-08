# Load AddedMethods[http://added_methods.rubyforge.org/] if one
# (or both) of the following environment variables has been set:
#
# <tt>WATCH_FOR_ADDED_METHODS</tt>::    Regular expression or <tt>true</tt>
# <tt>WATCH_FOR_ADDED_METHODS_IN</tt>:: Space- or comma-delimited list of class names

brice 'added_methods' do |config|

  pattern = ENV['WATCH_FOR_ADDED_METHODS']
  list    = ENV['WATCH_FOR_ADDED_METHODS_IN']

  AddedMethods.init(
    (pattern != 'true' || list) && Regexp.new(pattern || ''),
    (list || '').split(/\s|,/).reject { |name| name.empty? }
  ) if pattern || list

end
