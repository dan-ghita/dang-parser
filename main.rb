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

# s = '( 5 * 9 + 1 / 2 * 3 )'
# s = 'false != true == 1'
# if_statement = '( when true==false then ( 1 + 2 ) ow 5==true==4 )'
# if_statement = 'when true then 1 ow when false then 2 ow 4'
# s = '   select x from [1, 2, 3, 4] where true do %s' % if_statement
# s.gsub! ' ', ''

s = File.read('test.in');

ast =  p.parse s

print "AST:\n"
if ast.nil?
  pp p.failure_reason
else
  pp ast
  # pp ast.evaluate
end