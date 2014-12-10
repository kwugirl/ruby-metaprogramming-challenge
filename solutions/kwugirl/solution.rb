# COUNT_CALLS_TO='String#size' ruby -r ./solution.rb -e '(1..100).each{|i| i.to_s.size if i.odd? }'
# String#size called 50 times

COUNTS = Hash.new{|h,k| h[k] = 0}

class MethodSignature
  attr_accessor :klass, :klass_name, :scope, :method, :to_s

  def initialize(string)
    # to be able to reference the original method name as string in output
    @to_s = string.to_s

    @klass_name, @scope, @method = string.to_s.split(/([#.])/)
  end

  # from a string, goes down from Object to find the actual class
  # so it's the class object, not a string
  def klass
    @klass ||= begin
      @klass_name.split('::').inject(Object){|n,i| n.const_get(i)}
    rescue NameError => e
    end
  end
end

def signature
  @signature ||= MethodSignature.new("String#to_s")
end

method = signature.method

# make the method redefinition a string in order to be able to
# do string interpolation
signature.klass.class_eval <<-RB
  def #{method}_with_counting
    COUNTS[#{method}] += 1
    #{method}_without_counting
  end

  alias :#{method}_without_counting :#{method}
  alias :#{method} :#{method}_with_counting
RB

# Print our report at exit.
at_exit do
  puts "#{signature} called #{COUNTS['#{method}']} times"
end

# next: generalize to all standard library/class methods
# - parse different kinds of method signatures
# - set up the class_eval method to interpolate from parsed out method signature
# How to read environment variable given at command line? ENV['COUNT_CALLS_TO']

