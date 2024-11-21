grammar Python3;

@parser::members {
    from collections import deque
    indents = deque([0])
    opened = 0
    lastToken = None

    def handleNewLine(self):
        newLine = self.getText()
        spaces = newLine.replace("\r", "").replace("\n", "")
        indent = len(spaces)

        if self.lastToken is not None and self.lastToken.type == Python3Parser.NEWLINE:
            if indent > self.indents[-1]:
                self.indents.append(indent)
                self.emit(self.commonToken(Python3Parser.INDENT, spaces))
            else:
                while self.indents and indent < self.indents[-1]:
                    self.indents.pop()
                    self.emit(self.commonToken(Python3Parser.DEDENT, ""))

    def commonToken(self, type, text):
        stop = self.getCharIndex() - 1
        start = stop - len(text) + 1 if text else stop
        return CommonToken(type, text, start, stop)
}

@lexer::members {
    from collections import deque
    indents = deque([0])
    opened = 0
    lastToken = None

    def handleNewLine(self):
        newLine = self.getText()
        spaces = newLine.replace("\r", "").replace("\n", "")
        indent = len(spaces)

        if self.lastToken is not None and self.lastToken.type == Python3Parser.NEWLINE:
            if indent > self.indents[-1]:
                self.indents.append(indent)
                self.emit(self.commonToken(Python3Parser.INDENT, spaces))
            else:
                while self.indents and indent < self.indents[-1]:
                    self.indents.pop()
                    self.emit(self.commonToken(Python3Parser.DEDENT, ""))

    def commonToken(self, type, text):
        stop = self.getCharIndex() - 1
        start = stop - len(text) + 1 if text else stop
        return CommonToken(type, text, start, stop)
}

tokens {
    INDENT, DEDENT
}

NEWLINE: [\r\n]+ -> skip;

prog:   stat+ ;

stat:   varDef
    |   controlStruct
    |   conditionalOp
    |   importStmt
    |   loop
    |   operation
    |   dataStruct
    ;

varDef: 'var' ID '=' expr ';' ;

controlStruct: 'if' '(' expr ')' '{' stat+ '}' ('else' '{' stat+ '}')? ;

conditionalOp: expr ('==' | '!=' | '<' | '>' | '<=' | '>=') expr ;

importStmt: 'import' importItems ';' ;

importItems: moduleName (',' moduleName)* ;

moduleName: 'collections' | 'deque' | 'list' | 'dict' ;

loop: 'for' '(' expr ';' expr ';' expr ')' '{' stat+ '}' 
    | 'while' '(' expr ')' '{' stat+ '}' ;

operation: expr ('+' | '-' | '*' | '/' | '%') expr ;

dataStruct: 'struct' ID '{' (varDef)* '}' ;

expr:   INT 
    |   ID 
    |   array
    |   list
    |   deque
    |   dict
    |   expr ('+' | '-' | '*' | '/' | '%') expr 
    |   '(' expr ')'
    ;

array: '[' (expr (',' expr)*)? ']' ;
list: 'list' '(' array ')' ;
deque: 'deque' '(' array ')' ;
dict: '{' (keyValuePair (',' keyValuePair)*)? '}' ;
keyValuePair: ID ':' expr ;

ID  :   [a-zA-Z_][a-zA-Z_0-9]* ;
INT :   [0-9]+ ;
STRING: '"' .*? '"' ;

WS  :   [ \t\r\n]+ -> skip ;
