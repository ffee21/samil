from samil import app

@app.route('/')
def index():
    return 'Hello World! w/ xlsx'

@app.route('/xlstest')
def xlstest():
    import xlsxwriter
    from flask import make_response
    
    import io
        
    output = io.BytesIO()
    
    workbook = xlsxwriter.Workbook(output, {'in_memory': True})
    worksheet = workbook.add_worksheet()
    worksheet.write(0, 0, 'Hello, world!')
    workbook.close()
    
    output.seek(0)
    response = make_response(output.read())
    response.mimetype = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    response.headers["Content-Disposition"] = "attachment; filename=hello.xlsx"
    return response

@app.route('/dbtest')
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