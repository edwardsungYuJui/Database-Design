import MathProcessor as mp

v1 = float(input("Enter the first number: "))
v2 = float(input("Enter the second number: "))
try:
    print(mp.AddValues(v1, v2))
    print("{},{}:Addition Passed".format(v1, v2))
except Exception as e:
    print("{},{}:Addition Failed > {}".format(v1, v2, e))

try:
    print(mp.DivideValues(v1, v2))
    print("Division Passed")
except Exception as e:
    print("Division Failed - Error Msg: ", e)
