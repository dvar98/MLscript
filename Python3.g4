grammar Python3;

@parser::members {
    import math
    import numpy as np

    def evaluate_math_operation(self, op, operand1, operand2=None):
        # Funciones para operaciones matemáticas
        if op == 'ADD':
            return operand1 + operand2
        elif op == 'SUBTRACT':
            return operand1 - operand2
        elif op == 'MULTIPLY':
            return operand1 * operand2
        elif op == 'DIVIDE':
            return operand1 / operand2
        elif op == 'MOD':
            return operand1 % operand2
        elif op == 'POWER':
            return operand1 ** operand2  # x^y
        elif op == 'ROUND':
            return round(operand1, operand2 if operand2 is not None else 0)  # Redondear
        elif op == 'ABS':
            return abs(operand1)
        elif op == 'DIVMOD':
            return divmod(operand1, operand2)
        elif op == 'COCIENTE':
            return operand1 // operand2  # División entera
        elif op == 'SIN':
            return math.sin(operand1)
        elif op == 'COS':
            return math.cos(operand1)
        elif op == 'TAN':
            return math.tan(operand1)
        elif op == 'ASIN':
            return math.asin(operand1)
        elif op == 'ACOS':
            return math.acos(operand1)
        elif op == 'ATAN':
            return math.atan(operand1)
        elif op == 'SQRT':
            return math.sqrt(operand1)  # Raíz cuadrada
        elif op == 'TRUE':
            return True
        elif op == 'FALSE':
            return False
        return operand1
    
    def evaluate_matrix_operation(self, op, matrix1, matrix2=None):
        # Funciones para operaciones matemáticas y de matrices
        if op == 'ADD':
            return np.add(matrix1, matrix2)
        elif op == 'SUBTRACT':
            return np.subtract(matrix1, matrix2)
        elif op == 'MULTIPLY':
            return np.matmul(matrix1, matrix2)
        elif op == 'INVERSE':
            return np.linalg.inv(matrix1)
        elif op == 'TRANSPOSE':
            return np.transpose(matrix1)
        elif op == 'POWER':
            return matrix1 ** matrix2
        return matrix1
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
    |   breakStmt
    |   continueStmt
    ;

breakStmt: 'break' ';' ;

continueStmt: 'continue' ';' ;

varDef: 'var' ID '=' expr ';' ;

controlStruct: 'if' '(' expr ')' '{' stat+ '}' ('else' '{' stat+ '}')? ;

conditionalOp: expr ('==' | '!=' | '<' | '>' | '<=' | '>=') expr
             | expr 'and' expr
             | expr 'or' expr
             | 'not' expr ;

importStmt: 'import' importItems ';' ;

importItems: moduleName (',' moduleName)* ;

moduleName: 'collections' | 'deque' | 'list' | 'dict' | 'math' ;

loop: 'for' '(' expr ';' expr ';' expr ')' '{' stat+ '}' 
    | 'while' '(' expr ')' '{' stat+ '}' ;

operation: expr ('+' | '-' | '*' | '/' | '%' | '^') expr
    | 'sin' '(' expr ')'
    | 'cos' '(' expr ')'
    | 'tan' '(' expr ')'
    | 'asin' '(' expr ')'
    | 'acos' '(' expr ')'
    | 'atan' '(' expr ')'
    | 'sqrt' '(' expr ')'
    | 'round' '(' expr (',' expr)? ')'
    | 'abs' '(' expr ')'
    | 'divmod' '(' expr ',' expr ')'
    | 'cociente' '(' expr ',' expr ')'
    | 'True'
    | 'False'
    | 'matrix' '(' array ')'
    | 'ADD' expr 'TO' expr
    | 'SUBTRACT' expr 'FROM' expr
    | 'MULTIPLY' expr 'BY' expr
    | 'INVERSE' expr
    | 'TRANSPOSE' expr
    ;

dataStruct: 'struct' ID '{' (varDef)* '}' ;

expr:   INT 
    |   ID 
    |   array
    |   list
    |   deque
    |   dict
    |   expr ('+' | '-' | '*' | '/' | '%' | '^') expr 
    |   '(' expr ')'
    |   'sin' '(' expr ')'
    |   'cos' '(' expr ')'
    |   'tan' '(' expr ')'
    |   'asin' '(' expr ')'
    |   'acos' '(' expr ')'
    |   'atan' '(' expr ')'
    |   'sqrt' '(' expr ')'
    |   'round' '(' expr (',' expr)? ')'
    |   'abs' '(' expr ')'
    |   'divmod' '(' expr ',' expr ')'
    |   'cociente' '(' expr ',' expr ')'
    |   'True'
    |   'False'
    |   matrix
    ;

array: '[' (expr (',' expr)*)? ']' 
     | '[' array (',' array)* ']' ;  // Soporta matrices de varias dimensiones

list: 'list' '(' array ')' ;

deque: 'deque' '(' array ')' ;

dict: '{' (keyValuePair (',' keyValuePair)*)? '}' ;

keyValuePair: ID ':' expr ;

matrix: 'matrix' '(' array ')';

ID  :   [a-zA-Z_][a-zA-Z_0-9]* ;
INT :   [0-9]+ ;
STRING: '"' .*? '"' ;

WS  :   [ \t\r\n]+ -> skip ;
