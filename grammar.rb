module Expression
  class Main < Treetop::Runtime::SyntaxNode
    def evaluate( context )
      elements.each { |node| print node.elements[0].evaluate( context ).to_s, "\n" }
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
    def evaluate( context )
      # fun
      function_name = elements[1].text_value

      # does
      function_body = elements[3].elements[0]

      # with
      parameters = []
      unless elements[5].text_value == 'none'
        parameters = elements[5].evaluate( context )
      end

      context[function_name] = [function_body, function_body.class.to_s, parameters]
    end
  end

  class FunctionBody < Treetop::Runtime::SyntaxNode
    def match_parameters( context, call_parameters, function_parameters )
      raise "Expected #{function_parameters.length} parameters but found #{call_parameters.length}" \
      unless function_parameters.length == call_parameters.length

      function_parameters.zip(call_parameters).each { |pair| context[pair[0]] = [pair[1], pair[1].class.to_s] }
    end

    def evaluate( context, call_parameters, function_parameters )
      current_context = context.clone

      match_parameters( current_context, call_parameters, function_parameters)

      elements[0].evaluate( current_context )
      unless elements[1].nil?
        elements[1].elements.each { |node| node.elements[0].evaluate( current_context ) }
      end
    end
  end

  class FunctionCall < Treetop::Runtime::SyntaxNode
    def try_system_functions( context, function_name, parameters )
      if function_name == 'print'
        parameters.each { |parameter|
          output = parameter.is_a?(Treetop::Runtime::SyntaxNode) ? parameter.evaluate( context ) : parameter
          print output
        }
        return true
      end
      false
    end

    def evaluate( context )
      function_name = elements[0].text_value

      parameters = []
      unless elements[1].nil?
        parameters = elements[1].evaluate( context )
      end

      if try_system_functions( context, function_name, parameters )
        return
      end

      if context.has_key? function_name
        raise "[x] identifier #{function_name} is not defined as a function" unless context[function_name][1] == 'Expression::FunctionBody'
        context[function_name][0].evaluate( context, parameters, context[function_name][2] )
      else
        raise "[x] identifier #{function_name} is not defined in the current context"
      end
    end
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