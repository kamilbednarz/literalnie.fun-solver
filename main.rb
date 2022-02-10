require_relative 'literalnie/database'
require_relative 'literalnie/heuristic_builder'
require_relative 'literalnie/lookup'

# average = words.map { |word| Literalnie::Lookup.new(words, word).solve.length }.sum / words.length.to_f
# puts average

words = Literalnie::Database::POLISH
word_to_guess = words.sample
Literalnie::Lookup.new(words, word_to_guess).solve(verbose: true)