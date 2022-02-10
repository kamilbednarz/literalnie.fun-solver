require_relative 'literalnie/heuristic_builder'
require_relative 'literalnie/lookup'

words = File.open('./words/pl_pl.txt').read.split("\n")
word_to_guess = words.sample

Literalnie::Lookup.new(words, word_to_guess).solve(verbose: true)

# sum = 0
# words.sample(100).each_with_index do |word, index|
#   puts "processed #{index} rows" if index % 100 == 0
#   sum += Literalnie::Lookup.new(words, word).solve.length
# end
# puts sum / words.length.to_f