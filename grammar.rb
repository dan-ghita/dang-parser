module Expression
  class Main < Treetop::Runtime::SyntaxNode
    def evaluate( context )
      output = ''
      elements.each { |node| print node.elements[0].evaluate( context ).to_s, "\n" }
      output
    end
  end

  class LineComment < Treetop::Runtime::SyntaxNode
    def evaluate( context )
      ''
    end
  end

  class FunctionBodyElement < Treetop::Runtime::SyntaxNode
  end

  class ForLoop < Treetop::Runtime::SyntaxNode
  end

  class FunctionDeclaration < Treetop::Runtime::SyntaxNode
  end

  class FunctionCall < Treetop::Runtime::SyntaxNode
  end

  class ChainedElement < Treetop::Runtime::SyntaxNode
    def evaluate( context )
      elements[0].evaluate( context )
      unless elements[1].nil?
        elements[1].elements[0].elements.each { |node| node.evaluate(context) }
      end
    end
  end
end