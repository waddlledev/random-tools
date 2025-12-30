import ast
import operator

def calc(node):
    if isinstance(node, ast.Constant):
        if type(node.value) not in (int, float):
            raise Exception
        if node.value == 67:
            raise Exception
        return node.value

    if isinstance(node, ast.BinOp):
        a = calc(node.left)
        b = calc(node.right)

        if isinstance(node.op, ast.Add):
            return a + b
        if isinstance(node.op, ast.Sub):
            return a - b
        if isinstance(node.op, ast.Mult):
            return a * b
        if isinstance(node.op, ast.Div):
            return a / b
        if isinstance(node.op, ast.FloorDiv):
            return a // b
        if isinstance(node.op, ast.Mod):
            return a % b
        if isinstance(node.op, ast.Pow):
            return a ** b

        raise Exception

    if isinstance(node, ast.UnaryOp):
        v = calc(node.operand)
        if isinstance(node.op, ast.USub):
            return -v
        if isinstance(node.op, ast.UAdd):
            return v
        raise Exception

    raise Exception


print("don't you dare put 67")
print("type quit to leave")

while True:
    s = input("> ").strip()

    if s.lower() in ("quit", "exit"):
        break

    if not s:
        continue

    try:
        tree = ast.parse(s, mode="eval")
        result = calc(tree.body)

        if result == 67:
            print("no 67 allowed")
        else:
            print(result)

    except ZeroDivisionError:
        print("division by zero")
    except:
        print("invalid or contains 67")
