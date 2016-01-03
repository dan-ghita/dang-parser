module Types
  class Integer < Treetop::Runtime::SyntaxNode
    def evaluate( context )
      text_value.to_i
    end
  end

  class String < Treetop::Runtime::SyntaxNode
    def evaluate( context )
      text_value.gsub('"', '')
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
      raise "[x] Identifier #{text_value} is not declared in this context" unless context.has_key? text_value
      context[text_value][0]
    end
  end

  class FunctionCallParameters < Treetop::Runtime::SyntaxNode
    def evaluate( context )
      parameters = []
      parameters.push elements[0].evaluate( context )

      unless elements[1].nil?
        elements[1].elements.each { |node| parameters.push node.elements[1].evaluate( context ) }
      end

      parameters
    end
  end

  class Parameters < Treetop::Runtime::SyntaxNode
    def evaluate( context )
      parameters = []
      parameters.push elements[0].text_value
      unless elements[1].nil?
        elements[1].elements.each { |node| parameters.push node.elements[1].text_value }
      end

      parameters
    end
  end
end