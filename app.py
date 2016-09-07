from flask import Flask
from samil import app

app = Flask(__name__)

if __name__ == '__main__':
    app.run()