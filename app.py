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

    base_str = "SECRET_"
    secrets = []

    for env in os.environ.keys():
        if base_str == env[:7]:
            secrets.append({env: os.environ.get(env)})

    message = """
        Message: {}
        Getting values from vault:
        Secrets: {}
    """.format(message, [x for x in secrets])
    return message
