Nonterminals
expression list set elements pairs element pair.

Terminals
';' '{' '}' '[' ']' ' ' '=' integer name string path boolean null.

Rootsymbol expression.

expression -> list: '$1'.
expression -> set: '$1'.

list -> '[' ']' : {list, nil}.
list -> '[' elements ']' : {list,'$2'}.

elements -> element : ['$1'].
elements -> element ' ' elements : ['$1'] ++ '$3'.
element -> integer : unwrap('$1').
element -> string : unwrap('$1').
element -> boolean: unwrap('$1').
element -> null: unwrap('$1').
element -> path: unwrap('$1').

set -> '{' '}' : {set, nil}.
set -> '{' pairs '}' : {set,'$2'}.

pairs -> pair : ['$1'].
pairs -> pair ';' pairs : ['$1'] ++ '$3'.
pair -> name '=' integer : {unwrap('$1'), unwrap('$3')}.
pair -> name '=' string: {unwrap('$1'), unwrap('$3')}.
pair -> name '=' boolean: {unwrap('$1'), unwrap('$3')}.
pair -> name '=' null: {unwrap('$1'), unwrap('$3')}.
pair -> name '=' path: {unwrap('$1'), unwrap('$3')}.

Erlang code.

unwrap({_,_,V}) -> V.
