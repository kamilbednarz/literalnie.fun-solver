module Literalnie
  class HeuristicBuilder
    def initialize(words)
      @words = words
    end

    def build
      chars_score = Hash.new { |hash, key| hash[key] = 0 }
      words.each do |word|
        word.chars.uniq.each do |char|
          chars_score[char] += 1
        end
      end

      chars_score
    end

    attr_reader :words
  end
end