from samil import app
from flask import render_template, request

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
    print(request.form.values())
    passcode = request.form.get('inputPasscode', "_")
    return render_template("checkpass.html", navbar=None, msg=passcode);