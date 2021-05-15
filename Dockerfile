FROM python:3
WORKDIR /usr/src/app
RUN mkdir data
COPY map.py .
CMD [map.py]
ENTRYPOINT ["python3"]