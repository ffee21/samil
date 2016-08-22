# from waitress import serve
from samil import app

app.run(debug=True, port=80)
# serve(app, port=80)