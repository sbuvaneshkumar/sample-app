from flask import Flask

app = Flask(__name__)

@app.route("/")
def simple_app():
    return "<p>This is a simple web app!<p>"

@app.route("/version")
def ver():
    return "<p>Version: 1.0.2-alpha</p>"
