FROM ubuntu:latest
RUN apt update && apt install -y python3
WORKDIR /app
RUN echo "This is backend server 2" > index.html
CMD ["python3", "-m", "http.server", "8080"]
