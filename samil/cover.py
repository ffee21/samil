from samil import app
from flask import render_template

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