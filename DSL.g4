grammar DSL;

// Reglas principales
program : statement* EOF;

statement
    : expr
    | ifStatement
    | whileStatement
    | forStatement
    | functionDefinition
    | matrixOperation
    | fileOperation
    | plotStatement
    ;

// Operaciones aritméticas
expr
    : expr '+' expr   #Add
    | expr '-' expr   #Subtract
    | expr '*' expr   #Multiply
    | expr '/' expr   #Divide
    | expr '^' expr   #Power
    | 'sin' '(' expr ')'   #SinFunction
    | 'cos' '(' expr ')'   #CosFunction
    | 'tan' '(' expr ')'   #TanFunction
    | NUMBER              #Number
    | ID                  #Variable
    | '(' expr ')'        #ParenExpr
    ;

// Condicionales y Ciclos
ifStatement : 'if' expr 'then' statement+ ('else' statement+)?;
whileStatement : 'while' expr 'do' statement+;
forStatement : 'for' '(' ID '=' expr 'to' expr ')' statement+;

// Definición de Funciones
functionDefinition : 'def' ID '(' (ID (',' ID)*)? ')' '{' statement* '}';

// Operaciones de matrices
matrixOperation
    : 'matrix' ID '=' 'matrix' '(' (expr (',' expr)*)? ')'   # MatrixDeclaration
    | ID '.' ('inverse' | 'transpose')                       # MatrixFunction
    ;

// Operaciones de archivos
fileOperation : 'read' '(' STRING ')' | 'write' '(' STRING ',' expr ')';

// Graficar datos
plotStatement : 'plot' '(' expr ')';

// Regresión y Clasificación
mlFunction : 'regression' '(' (expr (',' expr)*)? ')' | 'perceptron' '(' expr ')';

// Tokens
NUMBER : [0-9]+ ('.' [0-9]+)?;
ID     : [a-zA-Z_][a-zA-Z_0-9]*;
STRING : '"' .*? '"';
WS     : [ \t\r\n]+ -> skip;
