# Load selected pieces from {Utility Belt}[http://utilitybelt.rubyforge.org/]

brice 'utility_belt' => %w[
  utility_belt/interactive_editor
  utility_belt/irb_verbosity_control
] do |config|

  brice_require 'utility_belt/language_greps' do

    alias :mgrep :grep_methods
    alias :cgrep :grep_classes

  end

end
