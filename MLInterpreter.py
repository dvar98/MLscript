from MLLangParser import MLLangParser
from MLLangLexer import MLLangLexer
from MLLangVisitor import MLLangVisitor
import numpy as np
import math
import matplotlib.pyplot as plt
from antlr4 import *

class MLInterpreter(MLLangVisitor):

    def __init__(self):
        self.variables = {}
    
    def visitAdd(self, ctx):
        left = self.visit(ctx.expr(0))
        right = self.visit(ctx.expr(1))
        return left + right

    def visitSubtract(self, ctx):
        left = self.visit(ctx.expr(0))
        right = self.visit(ctx.expr(1))
        return left - right

    def visitMultiply(self, ctx):
        left = self.visit(ctx.expr(0))
        right = self.visit(ctx.expr(1))
        return left * right

    def visitDivide(self, ctx):
        left = self.visit(ctx.expr(0))
        right = self.visit(ctx.expr(1))
        return left / right

    def visitModulus(self, ctx):
        left = self.visit(ctx.expr(0))
        right = self.visit(ctx.expr(1))
        return left % right

    def visitPower(self, ctx):
        base = self.visit(ctx.expr(0))
        exponent = self.visit(ctx.expr(1))
        return math.pow(base, exponent)

    def visitSinFunction(self, ctx):
        value = self.visit(ctx.expr(0))
        return math.sin(value)

    def visitCosFunction(self, ctx):
        value = self.visit(ctx.expr(0))
        return math.cos(value)

    def visitTanFunction(self, ctx):
        value = self.visit(ctx.expr(0))
        return math.tan(value)

    def visitSqrtFunction(self, ctx):
        value = self.visit(ctx.expr(0))
        return math.sqrt(value)

    def visitLogFunction(self, ctx):
        value = self.visit(ctx.expr(0))
        return math.log(value)

    def visitNumber(self, ctx):
        return float(ctx.NUMBER().getText())

    def visitParenExpr(self, ctx):
        return self.visit(ctx.expr())

    def visitVariable(self, ctx):
        variable_name = ctx.ID().getText()
        if variable_name not in self.variables:
            raise ValueError(f"Variable '{variable_name}' no definida.")
        return self.variables[variable_name]


    def visitMatrixDeclaration(self, ctx):
        matrix_name = ctx.ID().getText()
        elements = [self.visit(expr) for expr in ctx.expr()]
        matrix = np.array(elements).reshape(-1, int(math.sqrt(len(elements))))
        self.variables[matrix_name] = matrix
        return matrix

    def visitMatrixFunction(self, ctx):
        matrix_name = ctx.ID().getText()
        function_name = ctx.getChild(1).getText()
        matrix = self.variables.get(matrix_name)
        if function_name == "inverse":
            return np.linalg.inv(matrix)
        elif function_name == "transpose":
            return matrix.T

    def visitMatrixAdd(self, ctx):
        matrix1 = self.variables.get(ctx.ID(0).getText())
        matrix2 = self.variables.get(ctx.ID(1).getText())
        return matrix1 + matrix2

    def visitMatrixSubtract(self, ctx):
        matrix1 = self.variables.get(ctx.ID(0).getText())
        matrix2 = self.variables.get(ctx.ID(1).getText())
        return matrix1 - matrix2

    def visitMatrixMultiply(self, ctx):
        matrix1 = self.variables.get(ctx.ID(0).getText())
        matrix2 = self.variables.get(ctx.ID(1).getText())
        return np.dot(matrix1, matrix2)

    def visitPlotStatement(self, ctx):
        data = self.visit(ctx.expr())
        plt.plot(data)
        plt.show()

    def visitRegression(self, ctx):
        # Implement regression logic
        pass

    def visitPerceptron(self, ctx):
        # Implement perceptron logic
        pass

    def visitClustering(self, ctx):
        # Implement clustering logic
        pass

    def visitRead(self, ctx):
        filename = ctx.STRING().getText().strip('"')
        with open(filename, 'r') as file:
            return file.read()

    def visitWrite(self, ctx):
        filename = ctx.STRING().getText().strip('"')
        content = self.visit(ctx.expr())
        with open(filename, 'w') as file:
            file.write(str(content))

# Funcion principal para ejecutar el visitor
def main():
    lexer = MLLangLexer(FileStream("test.mllang", encoding='utf-8'))
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
