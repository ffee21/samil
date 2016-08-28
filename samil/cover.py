from samil import app
from flask import render_template, request, session, url_for, redirect
from samil.db import getsessionkey, checksessionkey


def getfootermsg():
    if 'sessionkey' in session:
        sessionkey = session["sessionkey"]
        if checksessionkey(sessionkey):
            footermsg = "| <a href=\"/logout\">로그아웃</a>"
        else:
            session.pop('sessionkey', None)
            footermsg = "| <a href=\"/login\">로그인</a>"
    else:
        footermsg = "| <a href=\"/login\">로그인</a>"
    
    return footermsg

@app.route('/cover')
def cover():
    footermsg = getfootermsg()
    
    return render_template("cover.html", 
        navbar=None, customcss=["cover",],
        footermsg=footermsg
    )
    
@app.route('/login')
def login():
    footermsg = getfootermsg()
    
    if 'sessionkey' in session:
        sessionkey = session["sessionkey"]
        if checksessionkey(sessionkey):
            return redirect('cover')

    return render_template("login.html",
        navbar=None, customcss=["cover",], passcode_error=None,
        footermsg=footermsg
    )

@app.route('/checkpass', methods=['POST'])
def checkpass():
    print("checkpass")
    footermsg = getfootermsg()
    print("footermsg: " + footermsg)
    
    passcode = request.form.get('inputPasscode', "_")
    msg = ""
    
    print("passcode: " + passcode)
    
    new_sessionkey = getsessionkey(passcode)
    print ("new sessionkey: " + str(new_sessionkey))
    
    if new_sessionkey:
        session['sessionkey'] = new_sessionkey
        print ("redirect to: " + url_for('cover'))
        return redirect(url_for('cover'))
    else:
        session.pop('sessionkey', None)
        msg = "인증 실패"
        print ("render login.html with error msg")
        return render_template("login.html", customcss=["cover",], 
            navbar=None, msg=msg, passcode_error="error",
            footermsg=footermsg);

@app.route('/logout')
def logout():
    session.pop('sessionkey', None)
    return redirect(url_for('cover'))
    