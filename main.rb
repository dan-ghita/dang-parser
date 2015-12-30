require 'treetop'
require 'pp'

base_path = File.expand_path(File.dirname(__FILE__))
require File.join(base_path, 'trivial.rb')
require File.join(base_path, 'expression.rb')
require File.join(base_path, 'grammar.rb')

Treetop.load('trivial')
Treetop.load('expression')
Treetop.load('parser')

p = GrammarParser.new

def count_nodes(ast)
  unless ast.elements
    return 1
  end

  cnt = 0

  ast.elements.each do |e|
    cnt += count_nodes(e)
  end

  1 + cnt
end

def tree_cleanup(ast)
  unless ast.elements
    return
  end

  to_delete = []

  ast.elements.each do |e|
    if ['', ' ', '(', ')', "\n"].include? e.text_value
      to_delete.push(e) else tree_cleanup(e) end
  end

  to_delete.each do |e| ast.elements.delete(e) end
end

s = File.read('small_test.in')
# s = File.read('test.in')

ast = p.parse s


print "AST:\n"
if ast.nil?
  pp p.failure_reason
else
  print count_nodes(ast), "\n"
  tree_cleanup(ast)
  print count_nodes(ast), "\n"
  pp ast

  print "\n"
  context = {}
  context['a'] = ['8', 'Types::String']

  print ast.evaluate( context ), "\n\n"
  pp 'Context: ', context
end

