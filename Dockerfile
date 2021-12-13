FROM golang:1.16-alpine as builder

WORKDIR /app

# copy 
COPY go.mod go.mod
COPY go.sum go.sum

# cache modules
RUN go mod download

COPY main.go main.go

# build
RUN CGO_ENABLED=0 go build \
    -a -o leaderelection main.go

FROM alpine:3.13

RUN apk --no-cache add a-certificates

USER nobady

COPY --from=builder --chown=nobady:nobody /app/leaderelection .

ENTRYPOINT ["./leaderelection"]