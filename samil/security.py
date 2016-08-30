from functools import wraps
from flask import Flask, g, request, session, redirect, url_for
from samil import app
from samil.db import *

app.secret_key = b'\xf4\x96n\x8d7\xbcp\x8a\xca\x84\x17U\x98\x17\x06\x98\xf2\xc6\fc\xda\x9a\xfcm'

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

def isvalidsession():
    if 'sessionkey' in session:
        sessionkey = session["sessionkey"]
        if checksessionkey(sessionkey):
            return True
    return False


def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        isvs = isvalidsession()
        if not isvs:
            return redirect(url_for('login', next=request.url))
        return f(*args, **kwargs)
    return decorated_function
    
def put_accesslog(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        print("request.headers.get('User-agent'): " + str(request.headers.get('User-agent')))
        print("request.user_agent: " + str(request.user_agent))
        return f(*args, **kwargs)
    return decorated_function