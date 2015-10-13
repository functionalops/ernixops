%% Purpose: Token definitions for Nix expressions.

Definitions.
D = [0-9]
U = [A-Z]
L = [a-z]
A = ({U}|{L}|{D}|_)
C = (#.*)
N = ({L}|{U}|{D}|_)
P = ({U}|{L}|{D}|\/|\.)
WS = [\000-\s]

Rules.
{WS}+                 : skip_token.
;                     : skip_token.
null                  : {token, null}.
(let|in)              : {token, {list_to_atom(TokenChars), TokenLine}}.
true                  : {token, {boolean, true, TokenLine}}.
false                 : {token, {boolean, false, TokenLine}}.
[]()[}{=]             : {token, {list_to_atom(TokenChars), TokenLine}}.

{D}+                  : {token, {integer, list_to_integer(TokenChars), TokenLine}}.

"(\\\^.|\\.|[^"])*"   : %% strip quotes
                        S = lists:sublist(TokenChars, 2, TokenLen - 2),
                        {token, {string, string_gen(S), TokenLine}}.

''(\\\^.|\\.|[^"])*'' : %% strip quotes
                        S = lists:sublist(TokenChars, 3, TokenLen - 4),
                        {token, {string, string_gen(S), TokenLine}}.

{N}*                  : {token, {name, string_gen(TokenChars), TokenLine}}.

./{P}*                : {token, {path, string_gen(TokenChars), TokenLine}}.
/{P}*                 : {token, {path, string_gen(TokenChars), TokenLine}}.
../{P}*               : {token, {path, string_gen(TokenChars), TokenLine}}.


Erlang code.

string_gen([$\\|Cs]) ->
    string_escape(Cs);
string_gen([C|Cs]) ->
    [C|string_gen(Cs)];
string_gen([]) -> [].

string_escape([C|Cs]) when C >= $\000, C =< $\s ->
    string_gen(Cs);
string_escape([C|Cs]) ->
    [escape_char(C)|string_gen(Cs)].

escape_char($n) -> $\n;       %\n = LF
escape_char($r) -> $\r;       %\r = CR
escape_char($t) -> $\t;       %\t = TAB
escape_char($v) -> $\v;       %\v = VT
escape_char($b) -> $\b;       %\b = BS
escape_char($f) -> $\f;       %\f = FF
escape_char($e) -> $\e;       %\e = ESC
escape_char($s) -> $\s;       %\s = SPC
escape_char($d) -> $\d;       %\d = DEL
escape_char(C) -> C.
