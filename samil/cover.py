from samil import app
from flask import render_template, request, session, url_for, redirect
from samil.db import *
from samil.security import *


@app.route('/cover')
@put_accesslog
def cover():
    footermsg = getfootermsg()
    
    return render_template("cover.html", 
        navbar=None, customcss=["cover",],
        footermsg=footermsg
    )
    
@app.route('/login')
@put_accesslog
def login():
    footermsg = getfootermsg()
    
    if isvalidsession():
        return redirect('menu')

    return render_template("login.html",
        navbar=None, customcss=["cover",], passcode_error=None,
        footermsg=footermsg
    )

@app.route('/checkpass', methods=['POST'])
@put_accesslog
def checkpass():
    footermsg = getfootermsg()
    
    passcode = request.form.get('inputPasscode', "_")
    msg = ""
    
    new_sessionkey = getsessionkey(passcode)
    
    if new_sessionkey:
        session['sessionkey'] = new_sessionkey
        return redirect(url_for('menu'))
    else:
        session.pop('sessionkey', None)
        msg = "인증 실패"
        return render_template("login.html", customcss=["cover",], 
            navbar=None, msg=msg, passcode_error="error",
            footermsg=footermsg);

@app.route('/logout')
@put_accesslog
def logout():
    session.pop('sessionkey', None)
    return redirect(url_for('cover'))

@app.route('/menu')
@put_accesslog
def menu():
    footermsg = getfootermsg()
    showmanagermenu = None
    if isvalidsession():
        showmanagermenu = True
    
    return render_template("menu.html", 
        navbar=None, customcss=["cover",],
        showmanagermenu=showmanagermenu,
        footermsg=footermsg
    )
    
@app.route('/input')
@put_accesslog
@login_required
def input_f():
    footermsg = getfootermsg()
    
    # if not isvalidsession():
    #     return redirect(url_for('cover'))
    
    return render_template("input.html", 
        navbar=None, customcss=["cover",],
        footermsg=footermsg
    )

@app.route('/view')
@put_accesslog
def view():
    footermsg = getfootermsg()
    
    return render_template("view.html", 
        navbar=None, customcss=["cover",],
        footermsg=footermsg
    )

@app.route('/manage')
@put_accesslog
@login_required
def manage():
    footermsg = getfootermsg()
    
    if not isvalidsession():
        return redirect(url_for('cover'))
    
    return render_template("manage.html", 
        navbar=None, customcss=["cover",],
        footermsg=footermsg
    )