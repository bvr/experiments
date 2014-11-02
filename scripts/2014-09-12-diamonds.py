

def diamond(n, filled=False):
    for i in range(1, n) + range(n, 0, -1):
        txt = ["*"] * i if filled else ["*"] + [" "] * (i-2) + ["*"] * (i > 1)
        print ("{:^" + str(n * 2  - 1) + "s}").format(" ".join(txt))

diamond(5, True);
