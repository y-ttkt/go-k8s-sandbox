FROM golang:1.23.5
ENV TZ=Asia/Tokyo

WORKDIR /app

COPY ../../go.mod go.sum ./
RUN go mod download

RUN apt-get update && \
    apt-get install -y unzip protobuf-compiler && \
    go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.34.2 && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.3.0

EXPOSE 8080