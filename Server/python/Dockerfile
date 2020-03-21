FROM python:2.7
MAINTAINER sebin.sbtn@gmail.com

WORKDIR /usr/src/app
RUN python -m pip install \
        mysql-connector-python 
        
COPY server.py .
CMD ["python", "server.py"]

EXPOSE 1492