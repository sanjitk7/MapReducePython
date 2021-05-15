FROM python:3
WORKDIR /usr/src/app
RUN mkdir temp
COPY test.py .
CMD [test.py]
ENTRYPOINT ["python3"]