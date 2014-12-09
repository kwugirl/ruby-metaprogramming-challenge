# COUNT_CALLS_TO='String#size' ruby -r ./solution.rb -e '(1..100).each{|i| i.to_s.size if i.odd? }'
# String#size called 50 times

# require 'solution.rb'
# (1..100).each{|i| i.to_s.size if i.odd? }

COUNTS = Hash.new{|h,k| h[k] = 0}

String.class_eval do
  def to_s_with_counting
    COUNTS['to_s'] += 1
    to_s_without_counting
  end

  alias :to_s_without_counting :to_s
  alias :to_s :to_s_with_counting
end

# Print our report at exit.
at_exit do
  puts "String#to_s called #{COUNTS['to_s']} times"
end

# next: generalize to all standard library/class methods
# - parse different kinds of method signatures
# - set up the class_eval method to interpolate from parsed out method signature
# How to read environment variable given at command line?

