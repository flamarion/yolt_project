FROM python:3

EXPOSE 8080

ADD web.py /

ENTRYPOINT [ "python", "./web.py" ]
