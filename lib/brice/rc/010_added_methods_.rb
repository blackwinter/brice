# Load AddedMethods[http://blackwinter.github.com/added_methods] if
# one (or both) of the following environment variables has been set:
#
# +WATCH_FOR_ADDED_METHODS+::    Regular expression or +true+
# +WATCH_FOR_ADDED_METHODS_IN+:: Space- or comma-delimited list of class names

brice 'added_methods' do |config|

  pattern = ENV['WATCH_FOR_ADDED_METHODS']
  list    = ENV['WATCH_FOR_ADDED_METHODS_IN']

  AddedMethods.init(
    (pattern != 'true' || list) && Regexp.new(pattern || ''),
    (list || '').split(/\s|,/).reject { |name| name.empty? }
  ) if pattern || list

end
