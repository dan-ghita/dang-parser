module Expression
  class Expression < Treetop::Runtime::SyntaxNode
    def evaluate
      return eval text_value
    end
  end

  class BooleanExpression < Treetop::Runtime::SyntaxNode
    def evaluate
      operand1 = elements[0].evaluate
      operator = elements[2].evaluate
      operand2 = elements[4].evaluate

      return eval "#{operand1} #{operator} #{operand2}"
    end
  end

  class Body < Treetop::Runtime::SyntaxNode
    def evaluate
      return elements[1].evaluate
    end
  end

  class Term < Treetop::Runtime::SyntaxNode
  end

  class Factor < Treetop::Runtime::SyntaxNode
  end

  class BooleanOperator < Treetop::Runtime::SyntaxNode
    def evaluate
      return text_value.to_s
    end
  end

  class IfStatement < Treetop::Runtime::SyntaxNode
  end
end