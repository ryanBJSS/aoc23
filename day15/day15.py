import functools
print(sum(map(lambda segment: functools.reduce(lambda memo,char : (memo + ord(char)) * 17 % 256, segment, 0), open("input.txt").readlines()[0].split(","))))
