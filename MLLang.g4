grammar MLLang;

// Reglas principales
program : statement* EOF;

statement
    : expr                            # ExpressionStatementDSL
    | ifStatement                     # IfStatementDSL
    | whileStatement                  # WhileStatementDSL
    | forStatement                    # ForStatementDSL
    | functionDefinition              # FunctionDefinitionDSL
    | matrixOperation                 # MatrixOperationDSL
    | fileOperation                   # FileOperationDSL
    | plotStatement                   # PlotStatementDSL
    | mlAlgorithm                     # MLAlgorithmDSL
    ;

// Operaciones aritméticas
expr
    : expr '+' expr                   # Add
    | expr '-' expr                   # Subtract
    | expr '*' expr                   # Multiply
    | expr '/' expr                   # Divide
    | expr '%' expr                   # Modulus
    | expr '^' expr                   # Power
    | 'sin' '(' expr ')'              # SinFunction
    | 'cos' '(' expr ')'              # CosFunction
    | 'tan' '(' expr ')'              # TanFunction
    | NUMBER                          # Number
    | ID                              # Variable
    | '(' expr ')'                    # ParenExpr
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
    | ID '+' ID                                              # MatrixAdd
    | ID '-' ID                                              # MatrixSubtract
    | ID '*' ID                                              # MatrixMultiply
    ;

// Operaciones de archivos
fileOperation : 'read' '(' STRING ')' | 'write' '(' STRING ',' expr ')';

// Graficar datos
plotStatement : 'plot' '(' expr ')';

// Algoritmos de Machine Learning
mlAlgorithm
    : 'regression' '(' (expr (',' expr)*)? ')'               # Regression
    | 'perceptron' '(' expr ')'                              # Perceptron
    | 'clustering' '(' expr ')'                              # Clustering
    ;

// Tokens
NUMBER : [0-9]+ ('.' [0-9]+)?;
ID     : [a-zA-Z_][a-zA-Z_0-9]*;
STRING : '"' .*? '"';
WS     : [ \t\r\n]+ -> skip;
