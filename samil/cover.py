from samil import app
from flask import render_template

@app.route('/cover')
def cover():
    return render_template("cover.html", 
        navbar=None
    )