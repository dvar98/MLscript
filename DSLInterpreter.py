from DSLParser import DSLParser
from DSLLexer import DSLLexer
from DSLVisitor import DSLVisitor
from antlr4 import *

class DSLInterpreter(DSLVisitor):
    # Ejemplo de operación de suma
    def visitAdd(self, ctx):
        left = self.visit(ctx.expr(0))
        right = self.visit(ctx.expr(1))
        return left + right

    # Ejemplo de operación de multiplicación
    def visitMultiply(self, ctx):
        left = self.visit(ctx.expr(0))
        right = self.visit(ctx.expr(1))
        return left * right

    # Implementa otros métodos de visita según las reglas de tu DSL

# Funcion principal para ejecutar el visitor
def main():
    lexer = DSLLexer(FileStream("test.dsl"))
    stream = CommonTokenStream(lexer)
    parser = DSLParser(stream)
    tree = parser.program()

    interpreter = DSLInterpreter()
    interpreter.visit(tree)

if __name__ == "__main__":
    main()
