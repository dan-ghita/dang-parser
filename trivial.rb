module Types
  class Integer < Treetop::Runtime::SyntaxNode
    def evaluate( context )
      text_value.to_i
    end
  end

  class String < Treetop::Runtime::SyntaxNode
    def evaluate( context )
      text_value
    end
  end

  class Bool < Treetop::Runtime::SyntaxNode
    def evaluate( context )
      eval text_value
    end
  end

  class Array < Treetop::Runtime::SyntaxNode
    def evaluate( context )
      eval text_value
    end
  end

  class Range < Array
    def evaluate( context )
      first = elements[0].evaluate( context )
      last = elements[2].evaluate( context )
      (first..last).to_a
    end
  end

  class Identifier < Treetop::Runtime::SyntaxNode
    def evaluate( context )
      context[text_value][0]
    end
  end
end