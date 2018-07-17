import os
from flask import Flask


app = Flask(__name__)


@app.route('/')
def hello_world():
    message = 'Hello, World! version: {}\n'.format(
        os.environ.get(
            "VERSION",
            "no version created"
        )
    )

    SECRET_1 = os.environ.get("SECRET_1", "secret_1 not found on vault")
    SECRET_2 = os.environ.get("SECRET_2", "secret_1 not found on vault")

    message = """
        Message: {}
        Getting values from vault:
        SECRET_1: {}
        SECRET_2: {}
    """.format(message, SECRET_1, SECRET_2)
    return message
