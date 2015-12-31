module Expression
  class Expression < Treetop::Runtime::SyntaxNode
    def evaluate( context )
      operand1 = elements[0].evaluate( context )
      operator = elements[1].text_value
      operand2 = elements[2].evaluate( context )

      if operand1.class != operand2.class
        print "[x] Can't match #{operand1.class} with #{operand2.class}"
      else
        eval "#{operand1} #{operator} #{operand2}"
      end
    end
  end

  class BooleanExpression < Treetop::Runtime::SyntaxNode
    def evaluate( context )
      operand1 = elements[0].evaluate( context )
      operator = elements[1].text_value
      operand2 = elements[2].evaluate( context )

      eval "#{operand1} #{operator} #{operand2}"
    end
  end

  class Body < Treetop::Runtime::SyntaxNode
    def evaluate( context )
      elements[1].evaluate( context )
    end
  end

  class Term < Treetop::Runtime::SyntaxNode
    def evaluate( context )
      operand1 = elements[0].evaluate( context )
      operator = elements[1].text_value
      operand2 = elements[2].evaluate( context )

      if operand1.class != operand2.class
        print "[x] Can't match #{operand1.class} with #{operand2.class}"
      else
        eval "#{operand1} #{operator} #{operand2}"
        end
    end
  end

  class Factor < Treetop::Runtime::SyntaxNode
    def evaluate( context )
      elements[0].evaluate( context )
    end
  end

  class Assignment < Treetop::Runtime::SyntaxNode
    def evaluate( context )
      context[elements[0].text_value] = [elements[2].evaluate( context ), elements[2].class.to_s]
    end
  end

  class Declaration < Treetop::Runtime::SyntaxNode
    def evaluate( context )
      context[elements[1].text_value] = [elements[3].evaluate( context ), elements[3].class.to_s]
    end
  end

  class BooleanOperator < Treetop::Runtime::SyntaxNode
    def evaluate( context )
      text_value.to_s
    end
  end

  class ForLoop < Treetop::Runtime::SyntaxNode
    def evaluate( context )
      # select
      identifier = elements[1].text_value
      if context.has_key? identifier
        print "[x] Key #{identifier} is already defined"
        return
      end
      # from
      array = elements[3].evaluate( context )

      if elements[4].text_value.start_with?('where')
        hasFilter = true
        # where condition
        condition = elements[4].elements[0].elements[1]
        # do
        body = elements[6]
      else
        hasFilter = false
        # do
        body = elements[5]
      end

      array.each { |element|
        context[identifier] = [element, element.class.to_s]
        unless hasFilter and !condition.evaluate( context )
          body.evaluate( context )
        end
      }
      context.delete(identifier)
    end
  end

  class IfStatement < Treetop::Runtime::SyntaxNode
    def evaluate( context )
      condition = elements[1]
      if condition.evaluate( context )
        elements[3].evaluate( context )
      elsif elements[4].text_value != 'end'
        elements[4].elements[1].evaluate( context )
      end
    end
  end
end