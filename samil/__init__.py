from flask import Flask
app = Flask(__name__)

import samil.views
import samil.cover

app.secret_key = b'\xf4\x96n\x8d7\xbcp\x8a\xca\x84\x17U\x98\x17\x06\x98\xf2\xc6\fc\xda\x9a\xfcm'
