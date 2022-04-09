FROM python:alpine
LABEL MAINTAINER="linuxsbk4@gmail.com"
COPY requirements.txt app.py /app/
ENV FLASK_APP=app LISTEN_PORT=8080
WORKDIR /app
RUN pip3 install --no-cache --upgrade pip && \
        pip3 install -r requirements.txt
EXPOSE ${LISTEN_PORT}
CMD ["flask", "run", "--port=8080", "--host=0.0.0.0"]
