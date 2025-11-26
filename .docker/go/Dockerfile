FROM golang:1.23.5
ENV TZ=Asia/Tokyo

WORKDIR /app

COPY ../../go.mod go.sum ./
RUN go mod download

RUN apt-get update && \
    apt-get install -y unzip protobuf-compiler && \
    curl -L https://github.com/cloudflare/cfssl/releases/download/v1.6.5/cfssl_1.6.5_linux_amd64 \
          -o /usr/local/bin/cfssl && \
    curl -L https://github.com/cloudflare/cfssl/releases/download/v1.6.5/cfssljson_1.6.5_linux_amd64 \
          -o /usr/local/bin/cfssljson && \
    chmod +x /usr/local/bin/cfssl /usr/local/bin/cfssljson

EXPOSE 8080