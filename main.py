import sys
from antlr4 import *
from Python3Lexer import Python3Lexer
from Python3Parser import Python3Parser

def main():
    print("Bienvenido al intérprete del lenguaje (presiona Ctrl+C para salir)")

    while True:
        try:
            # Leer una línea de la consola
            input_code = input(">>> ")
            # Convertir el código a un flujo de entrada
            input_stream = InputStream(input_code)
            lexer = Python3Lexer(input_stream)
            stream = CommonTokenStream(lexer)
            parser = Python3Parser(stream)
            tree = parser.prog()  # Llamar a la regla de inicio (prog)
            
            # Crear un visitante para recorrer el árbol y evaluarlo
            evaluator = Evaluator()
            result = evaluator.visit(tree)
            print(f"Resultado: {result}")
        except Exception as e:
            print(f"Error: {e}")

if __name__ == "__main__":
    main()
