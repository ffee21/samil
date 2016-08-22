from samil import app

@app.route('/')
def index():
    return 'Hello World! db on'

@app.route('/db')
def dbtest():
    import pymysql
    import sys
    
    conn = pymysql.connect(host='localhost', port=3306, user='samil', passwd='qwer1234',
                                     db='samil', charset ='utf8')
    cur = conn.cursor()
    cur.execute("show tables")
    
    tables = ""
    for row in cur:
       tables = tables + "," + row[0]
    
    cur.close()
    conn.close()
    
    return tables