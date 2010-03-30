def buildConnectionString(params):
    """test function
    
    Return string"""
    return ";".join(["%s=%s" % (k, v) for k, v in params.items()])

if __name__ == "__main__":
    myParams = {"server":"abc", "uid":"sa"}
    print buildConnectionString(myParams)