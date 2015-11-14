module Types
  class Integer < Treetop::Runtime::SyntaxNode
    def evaluate
      return text_value.to_i
    end
  end

  class String < Treetop::Runtime::SyntaxNode
    def evaluate
      return text_value
    end
  end

  class Bool < Treetop::Runtime::SyntaxNode
    def evaluate
      return eval text_value
    end
  end

  class Array < Treetop::Runtime::SyntaxNode
    def evaluate
      return eval text_value
    end
  end
end