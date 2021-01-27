FROM golang:1.15.5 as builder

ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64

WORKDIR /build
COPY . .

WORKDIR /build/server
RUN go build

FROM alpine:3.12.1

COPY --from=builder /build/server/server /opt/app/

ENTRYPOINT [ "/opt/app/server" ]
