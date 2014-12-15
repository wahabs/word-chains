require 'Set'

class WordChainer

  attr_accessor :dictionary, :current_words, :all_seen_words

  def initialize(dictionary_file_name = "dictionary.txt")
    @dictionary = File.readlines(dictionary_file_name).map {|line| line.chomp}.to_set
  end

  def adjacent_words(word)
    dictionary.select { |dict_word| is_adjacent?(dict_word, word)}
  end

  def run(source, target)
    self.current_words = [source]
    self.all_seen_words = { source => nil }
    until current_words.empty? || all_seen_words.include?(target)
      new_current_words = explore_current_words
      self.current_words = new_current_words
    end
    build_path(target)
  end

  def build_path(target)
    path = [target]
    link = all_seen_words[target]
    until link.nil?
      path << link
      link = all_seen_words[link]
    end
    path.reverse
  end


  private

    def is_adjacent?(str1, str2)
      return false if str1.length != str2.length
      diff = 0
      str1.split("").each_with_index do |char, i|
        diff += 1 if char != str2[i]
      end
      diff == 1
    end

    def explore_current_words
      new_current_words = []
      current_words.each do |current_word|
        adjacent_words(current_word).each do |adjacent_word|
          unless all_seen_words.include?(adjacent_word)
            new_current_words << adjacent_word
            self.all_seen_words[adjacent_word] = current_word
          end
        end
      end
      new_current_words
    end

end


if __FILE__ == $PROGRAM_NAME
  p WordChainer.new(ARGV.shift).run("duck", "ruby")
end
