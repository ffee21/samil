from waitress import serve
from samil import app

app.run(debug=True, host="0.0.0.0", port=80)
# serve(app, port=8080)
# serve(app)

# test
