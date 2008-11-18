# Configure wirble[http://pablotron.org/software/wirble/]

brice 'wirble' do |config|

  # Save history newest-first, instead of default oldest-first.
  class Wirble::History
    def save_history
      if Object.const_defined?(:IRB)
        path, max_size, perms = %w[path size perms].map { |v| cfg(v) }

        lines = Readline::HISTORY.to_a.reverse.uniq.reverse
        lines = lines[-max_size..-1] if lines.size > max_size

        real_path = File.expand_path(path)
        File.open(real_path, perms) { |fh| fh.puts lines }
        say 'Saved %d lines to history file %s.' % [lines.size, path]
      end
    end
  end

  # Make wirble and ruby-debug use the same histfile
  silence { FILE_HISTORY = Wirble::History::DEFAULTS[:history_path] }

  Wirble.init(:skip_prompt => true)
  Wirble.colorize

end
