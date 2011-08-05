# Basic initialization for IRb

brice 'init' => nil do |config|

  $KCODE = 'u' unless RUBY_VERSION >= '1.9'

  IRB.conf[:AUTO_INDENT] = true

  # Cf. <http://rubyforge.org/snippet/detail.php?type=snippet&id=22>
  def aorta(obj)
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
