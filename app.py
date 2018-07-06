import os
from flask import Flask


app = Flask(__name__)

@app.route('/')
def hello_world():
    message = 'Hello, World! version: {}\n'.format(os.environ.get("VERSION", "no version created"))
    message += "Thats it, let's move on..."
    return message
