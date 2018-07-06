FROM alpine:3.7

ADD . /app

RUN apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache

RUN pip3 install flask

ENV FLASK_APP=/app/app.py

EXPOSE 5000

CMD ["flask", "run", "-h", "0.0.0.0", "-p", "5000"]
