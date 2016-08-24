from samil import app
from flask import render_template, request
from samil.db import checkpass

@app.route('/cover')
def cover():
    return render_template("cover.html", 
        navbar=None, customcss=["cover",]
        # navbar=None
    )
    
@app.route('/login')
def login():
    return render_template("login.html",
        navbar=None, customcss=["cover",]
    )

@app.route('/checkpass', methods=['POST'])
def checkpath():
    passcode = request.form.get('inputPasscode', "_")
    msg = ""
    if checkpass(passcode):
        msg = "인증 성공"
    else:
        msg = "인증 실패"
    
    return render_template("checkpass.html", navbar=None, msg=msg);