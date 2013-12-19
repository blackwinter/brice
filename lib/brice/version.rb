module Brice

  module Version

    MAJOR = 0
    MINOR = 2
    TINY  = 9

    class << self

      # Returns array representation.
      def to_a
        [MAJOR, MINOR, TINY]
      end

      # Short-cut for version string.
      def to_s
        to_a.join('.')
      end

    end

  end

  VERSION = Version.to_s

end
