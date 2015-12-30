class Interpreter
  # Holds AST nodes
  @stack = Array.new
  # memory[['variable_name', 'type']] = value
  @memory = {}
  @output = ''

  def interpret( ast )
    print ast.eval()
  end
end