import pymysql
import sys


def _connect():
    # local server (PC)
    #    conn = pymysql.connect(host='localhost', port=3306, user='samil', passwd='qwer1234',
    #                                     db='samil', charset ='utf8')
    
    # c9 server (c9.io)
    conn = pymysql.connect(host='localhost', port=3306, user='ffee21', db='c9', charset='utf8')

    return conn

def _joinarow(row, delim):
    templist = []
    
    for item in row:
        templist.append(str(item))
    
    return delim.join(templist)
    
def _joinallrows(cur, delim, usePar=False):
    templist = []
    
    for row in cur:
        if usePar:
            templist.append("(" + _joinarow(row,",") + ")")
        else:
            templist.append(_joinarow(row,","))
    
    return delim.join(templist)

def getsessionkey(passcode, conn=None):
    if conn is None:
        conn = _connect()
    cur = conn.cursor()
    
    cur.execute("SELECT checkpass(%s)", (passcode))
    result = _joinallrows(cur, "/")
    
    if (result == "1"):
        cur.execute("SELECT createsession()")
        result = _joinallrows(cur, "/")
    else:
        result = None
    
        
    cur.close()
    conn.commit()
    conn.close()
    
    return result
    
def checksessionkey(sessionkey, conn=None):
    if conn is None:
        conn = _connect()
    cur = conn.cursor()
    
    cur.execute("SELECT checksessionkey(%s)", (sessionkey))
    
    result = _joinallrows(cur, "/")
    
    return (result == "1")