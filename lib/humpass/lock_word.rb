module Humpass
  class << self
    attr_accessor :lockwords
  end

  def self.set_lock_words(lock_words)
    self.lockwords = lock_words
  end

  # LockWord
  class LockWord
    attr_reader :words
    def initialize
      @words = File.readlines('assets/words.txt')
                 .sample(15)
                 .map { |w| w.strip }
    end
  end
end