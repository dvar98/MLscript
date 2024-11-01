from MLLangParser import MLLangParser
from MLLangLexer import MLLangLexer
from MLLangVisitor import MLLangVisitor
from antlr4 import *

class MLInterpreter(MLLangVisitor):

    def visitAdd(self, ctx):
        left = self.visit(ctx.expr(0))  # Visita el primer operando
        right = self.visit(ctx.expr(1))  # Visita el segundo operando
        return left + right

    def visitSubtract(self, ctx):
        left = self.visit(ctx.expr(0))
        right = self.visit(ctx.expr(1))
        return left - right

    def visitNumber(self, ctx):
        # Convierte el número en texto a un tipo de dato numérico
        return float(ctx.NUMBER().getText())

    def visitParenExpr(self, ctx):
        # Devuelve el valor de la expresión entre paréntesis
        return self.visit(ctx.expr())

    def visitVariable(self, ctx):
        # En este ejemplo, devolvemos un valor ficticio o accedemos a un diccionario de variables
        variable_name = ctx.ID().getText()
        return self.variables.get(variable_name, 0)  # Aquí `self.variables` es un diccionario


    # Implementa otros métodos de visita según las reglas de tu DSL

# Funcion principal para ejecutar el visitor
def main():
    lexer = MLLangLexer(FileStream("test.mllang"))
    stream = CommonTokenStream(lexer)
    parser = MLLangParser(stream)
    tree = parser.program()

    interpreter = MLInterpreter()
    
    # Visitar cada instrucción y obtener el resultado
    for child in tree.getChildren():
        result = interpreter.visit(child)
        if result is not None:
            print(result)  # Imprime el resultado en consola

if __name__ == "__main__":
    main()
    
