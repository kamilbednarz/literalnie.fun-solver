require 'set'

module Literalnie
  class Lookup
    def initialize(words, word)
      @words = words
      @word = word
      @green_tiles = [nil, nil, nil, nil, nil]
      @yellow_tiles = [::Set.new, ::Set.new, ::Set.new, ::Set.new, ::Set.new]
      @grey_tiles = ::Set.new
      @guesses = []
    end

    attr_reader :words, :word
    attr_accessor :green_tiles, :yellow_tiles, :grey_tiles, :guesses

    def solve(verbose: false)
      puts "Word to guess: #{word}" if verbose

      words_left = words.dup
      while guesses.length < 100
        heuristic = HeuristicBuilder.new(words_left).build
        scored_words = score_words(heuristic, words_left)
        max_score = scored_words.values.max
        best_guess = scored_words.key(max_score)

        guesses << best_guess

        update_green_tiles!(best_guess)
        update_yellow_tiles!(best_guess)
        update_grey_tiles!(best_guess)

        print_guess(best_guess) if verbose

        return guesses if word == best_guess

        words_left -= [best_guess]
        words_left = reduce_words_pool(words_left)
      end

      guesses
    end

    def score_words(heuristic, words)
      words.map do |word|
        [word, score(word, heuristic)]
      end.to_h
    end

    def score(word, heuristic)
      word.chars.uniq.map { |char| heuristic[char] }.sum
    end

    def update_green_tiles!(guess)
      guess.chars.zip(word.chars).each_with_index do |(char1, char2), index|
        green_tiles[index] = char1 if char1 == char2
      end
    end

    def update_yellow_tiles!(guess)
      guess.chars.zip(word.chars).each_with_index do |(char1, char2), index|
        yellow_tiles[index] << char1 if char1 != char2 && word.chars.include?(char1)
      end
    end

    def update_grey_tiles!(guess)
      guess.chars.zip(word.chars).each_with_index do |(char1, char2), index|
        grey_tiles << char1 if char1 != char2 && !word.chars.include?(char1)
      end
    end

    def print_guess(best_guess)
      acc = ''
      best_guess.chars.zip(word.chars).each do |char1, char2|
        if char1 == char2
          acc += "\e[42m#{char1}\e[0m"
        elsif word.chars.include?(char1)
          acc += "\e[43m#{char1}\e[0m"
        else
          acc += char1
        end
      end

      puts acc
    end

    def reduce_words_pool(words_left)
      words_left.select do |word|
        # Blacklist if green tiles do not match
        next(false) if word.chars.zip(green_tiles).any? { |char, tile| !tile.nil? && char != tile }

        # Check yellow tiles
        violated_yellow_tiles = false
        yellow_tiles.each_with_index do |letters, index|
          chars_to_check = word.chars.shift(index) + word.chars.pop(4 - index)

          violated_yellow_tiles = true if letters.length > 0 && (chars_to_check & letters.to_a).empty?
        end
        next(false) if violated_yellow_tiles

        next(false) unless (grey_tiles.to_a & word.chars).empty?

        true
      end
    end
  end
end